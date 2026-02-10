#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <archivo.p12> <archivo.mobileprovision> <password_p12>"
    exit 1
fi

P12_FILE=$1
PROVISION_FILE=$2
P12_PASS=$3

echo "--------------------------------------------------------"
echo " ANALIZANDO COMPATIBILIDAD DE FIRMA DIGITAL"
echo "--------------------------------------------------------"

# 1. ANALIZAR EL P12
P12_DATA=$(openssl pkcs12 -in "$P12_FILE" -passin pass:"$P12_PASS" -nokeys -nodes -legacy 2>/dev/null)

if [ -z "$P12_DATA" ]; then
    echo " ERROR: No se pudo leer el P12. Contraseña incorrecta o requiere -legacy."
    exit 1
fi

P12_CN=$(echo "$P12_DATA" | openssl x509 -noout -subject -nameopt RFC2253 | sed 's/.*CN=\([^,]*\).*/\1/')
P12_FINGERPRINT=$(echo "$P12_DATA" | openssl x509 -noout -fingerprint -sha1 | cut -d'=' -f2)
P12_EXP=$(echo "$P12_DATA" | openssl x509 -noout -enddate | cut -d'=' -f2)

echo " Certificado P12:"
echo "   • Nombre: $P12_CN"
echo "   • Huella: $P12_FINGERPRINT"
echo "   • Expira: $P12_EXP"
echo ""

# 2. ANALIZAR EL MOBILEPROVISION
# Extraemos el XML interno una sola vez para ahorrar tiempo
TMP_XML="/tmp/provision_content.xml"
openssl smime -inform der -verify -in "$PROVISION_FILE" -noverify > "$TMP_XML" 2>/dev/null

PROF_NAME=$(grep -aA1 "Name" "$TMP_XML" | grep -oP '(?<=<string>).*?(?=</string>)' | head -1)
PROF_EXP=$(grep -aA1 "ExpirationDate" "$TMP_XML" | grep -oP '(?<=<date>).*?(?=</date>)')
TEAM_NAME=$(grep -aA1 "TeamName" "$TMP_XML" | grep -oP '(?<=<string>).*?(?=</string>)' | head -1)

echo " Perfil MobileProvision:"
echo "   • Perfil: $PROF_NAME"
echo "   • Equipo: $TEAM_NAME"
echo "   • Expira: $PROF_EXP"
echo ""

# 3. EXTRAER CERTIFICADOS AUTORIZADOS EN EL PERFIL
echo " Certificados autorizados en este perfil:"
MATCH_FOUND=false
# Extraemos cada certificado del XML, lo decodificamos y leemos su CN y Fingerprint
grep -oP '(?<=<data>).*?(?=</data>)' "$TMP_XML" | while read -r base64_cert; do
    CERT_INFO=$(echo "$base64_cert" | base64 -d | openssl x509 -inform der -noout -subject -fingerprint -sha1)
    CERT_CN=$(echo "$CERT_INFO" | grep "subject" | sed 's/.*CN=\([^,]*\).*/\1/')
    CERT_FP=$(echo "$CERT_INFO" | grep "fingerprint" | cut -d'=' -f2)

    if [ "$CERT_FP" == "$P12_FINGERPRINT" ]; then
        echo "    $CERT_CN (MATCH)"
        MATCH_FOUND=true
    else
        echo "   --- $CERT_CN"
    fi
done

echo "--------------------------------------------------------"
if [ "$MATCH_FOUND" = true ]; then
    echo " RESULTADO: ¡TODO OK! El P12 puede usar este perfil."
else
    echo " RESULTADO: ERROR DE CONCORDANCIA"
    echo "El P12 que tienes no está en la lista de arriba."
    echo "Debes buscar un P12 que se llame como alguno de los de la lista."
fi
echo "--------------------------------------------------------"

rm -f "$TMP_XML"