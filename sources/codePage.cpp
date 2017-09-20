#include <stdlib.h>
#include <string.h>
#include <QString>
#include <stdint.h>

const char *CP852_TO_UTF8[] = {
        "\xC3\x87",     "\xC3\xBC",     "\xC3\xA9",     "\xC3\xA2",	"\xC3\xA4",	"\xC5\xAF",	"\xC4\x87",	"\xC3\xA7",
        "\xC5\x82",	"\xC3\xAB",	"\xC5\x90",	"\xC5\x91",	"\xC3\xAE",	"\xC5\xB9",	"\xC3\x84",	"\xC4\x86",
        "\xC3\x89",	"\xC4\xB9",	"\xC4\xBA",	"\xC3\xB4",	"\xC3\xB6",	"\xC4\xBD",	"\xC4\xBE",	"\xC5\x9A",
        "\xC5\x9B",	"\xC3\x96",	"\xC3\x9C",	"\xC5\xA4",	"\xC5\xA5",	"\xC5\x81",	"\xC3\x97",	"\xC4\x8D",
        "\xC3\xA1",	"\xC3\xAD",	"\xC3\xB3",	"\xC3\xBA",	"\xC4\x84",	"\xC4\x85",	"\xC5\xBD",	"\xC5\xBE",
        "\xC4\x98",	"\xC4\x99",	"\xC2\xAC",	"\xC5\xBA",	"\xC4\x8C",	"\xC5\x9F",	"\xC2\xAB",	"\xC2\xBB",
        "\xE2\x96\x91",	"\xE2\x96\x92",	"\xE2\x96\x93",	"\xE2\x94\x82",	"\xE2\x94\xA4",	"\xC3\x81",	"\xC3\x82",	"\xC4\x9A",
        "\xC5\x9E",	"\xE2\x95\xA3",	"\xE2\x95\x91",	"\xE2\x95\x97",	"\xE2\x95\x9D",	"\xC5\xBB",	"\xC5\xBC",	"\xE2\x94\x90",
        "\xE2\x94\x94",	"\xE2\x94\xB4",	"\xE2\x94\xAC",	"\xE2\x94\x9C",	"\xE2\x94\x80",	"\xE2\x94\xBC",	"\xC4\x82",	"\xC4\x83",
        "\xE2\x95\x9A",	"\xE2\x95\x94",	"\xE2\x95\xA9",	"\xE2\x95\xA6",	"\xE2\x95\xA0",	"\xE2\x95\x90",	"\xE2\x95\xAC",	"\xC2\xA4",
        "\xC4\x91",	"\xC4\x90",	"\xC4\x8E",	"\xC3\x8B",	"\xC4\x8F",	"\xC5\x87",	"\xC3\x8D",	"\xC3\x8E",
        "\xC4\x9B",	"\xE2\x94\x98",	"\xE2\x94\x8C",	"\xE2\x96\x88",	"\xE2\x96\x84",	"\xC5\xA2",	"\xC5\xAE",	"\xE2\x96\x80",
        "\xC3\x93",	"\xC3\x9F",	"\xC3\x94",	"\xC3\x83",	"\xC5\x84",	"\xC5\x88",	"\xC5\xA0",	"\xC5\xA1",
        "\xC5\x94",	"\xC3\x9A",	"\xC5\x95",	"\xC5\xB0",	"\xC3\xBD",	"\xC3\x9D",	"\xC5\xA3",	"\xC2\xB4",
        "\xF0",		"\xCB\x9D",	"\xCB\x9B",	"\xCB\x87",	"\xCB\x98",	"\xC2\xA7",	"\xC3\xB7",	"\xC2\xB8",
        "\xC2\xB0",	"\xC2\xA8",	"\xCB\x99",	"\xC5\xB1",	"\xC5\x98",	"\xC5\x99",	"\xE2\x96\xA0",	"\xFF"
};

// ***************************** IBM852 TO UTF8 *****************************//

/*
 *
 */
int getNumBytesFor852Char(unsigned char an852Char) {

        if (an852Char < 0x80) {
                return 1;
        } else {
                return strlen(CP852_TO_UTF8[an852Char - 0x80]);
        }

}

/*
 *
 */
int getNumBytesUtfFor852String(char *an852String) {
        int tCnt;
        int tBytes;
        int tStrlen;

        tBytes = 0;
        tStrlen = strlen(an852String);
        for (tCnt = 0; tCnt < tStrlen; tCnt++) {
                tBytes += getNumBytesFor852Char(an852String[tCnt]);
        }

        return tBytes;
}

/*
 *
 */
char singleByte[] = { ' ', '\0' };
const char *getUtfSnippetFor852Char(unsigned char an852Char) {

        if (an852Char >= 0x80) {
                return CP852_TO_UTF8[an852Char - 0x80];
        } else {
                singleByte[0] = an852Char;
                return singleByte;
        }
}

/*
 *
 */
char *getUtfCharsFromCodePage(char *an852String) {
        char *tUtfString;
        const char *tUtfSnippet;
        int tUtfLen;
        int tCnt;
        int t852Len;

        tUtfLen = getNumBytesUtfFor852String(an852String);
        tUtfString = (char *)calloc(tUtfLen + 1, sizeof(char));
        t852Len = strlen(an852String);

        for (tCnt = 0; tCnt < t852Len; tCnt++) {
                tUtfSnippet = getUtfSnippetFor852Char(an852String[tCnt]);
                strcat(tUtfString, tUtfSnippet);
        }

        return tUtfString;

}


/*
 *
 */




// ***************************** UTF8 TO IBM852 *****************************//

/*
 *
 */
int getUtfTokenBytesNum(unsigned char aChar) {
        if (aChar < 0x80) {
                return 1;
        } else if (aChar >= 0xC2 && aChar <= 0xDF) {
                return 2;
        } else if (aChar >= 0xE0 && aChar <= 0xEF) {
                return 3;
        } else if (aChar >= 0xF0 && aChar <= 0xF4) {
                return 4;
        } else {
                return 1; // invalid
        }
}

/*
 *
 */
int getStrlenUtf(char *anUtfString) {
        int tCnt;
        int tChars;

        tCnt = 0;
        tChars = 0;
        while (anUtfString[tCnt] != '\0') {
                tCnt += getUtfTokenBytesNum(anUtfString[tCnt]);
                tChars++;
        }

        return tChars;
}

/*
 *
 *
 */
uint8_t getPageCharFor(unsigned char *anUtfToken) {
        const char *tToken;

        if (anUtfToken[0] < 0x80) {
                return anUtfToken[0];
        } else {
                int tCnt;

                for (tCnt = 0; tCnt < 0x80; tCnt++) {
                        tToken = CP852_TO_UTF8[tCnt];
                        if (strncmp((const char *)anUtfToken, tToken, strlen(tToken)) == 0) {
                                return (char)(tCnt + 0x80);
                        }
                }

                return ' ';
        }
}

/*
 *
 */
uint8_t *getCodePageCharsFromUtf(char *anUtfString) {

        uint8_t *tDestString;
        uint8_t tPageChar;
        int tCnt;
        int tChars;
        int tLength;

        tLength = getStrlenUtf(anUtfString);
        tDestString = (uint8_t *)calloc(tLength + 1, sizeof(uint8_t));
        tCnt = 0;
        tChars = 0;

        while (anUtfString[tCnt] != '\0' && tChars < tLength) {
                tPageChar = getPageCharFor((uint8_t *)(&(anUtfString[tCnt])));
                tDestString[tChars++] = tPageChar;
                tCnt += getUtfTokenBytesNum(anUtfString[tCnt]);
        }

        tDestString[tLength] = '\0';
        return tDestString;
}

const char *convertQStringToCharArray(QString t_string)
{
    QByteArray b_temp = t_string.toUtf8();
    char *c_array = b_temp.data();

    size_t len = strlen(c_array);
    char *t_array = (char *)malloc(len + 1);
    memcpy(t_array, c_array, len + 1);

    return t_array;
}

/*
 *
 */
uint8_t *getCodePageCharsFromUnicode(QString aUnicodeString) {

     const char *tUTFString = convertQStringToCharArray(aUnicodeString);
        uint8_t *t852String = getCodePageCharsFromUtf((char *)tUTFString);
        return t852String;
}
