## [How do I make my own bundle file from CRT files?](https://support.comodo.com/index.php?/Knowledgebase/Article/View/1145/1/how-do-i-make-my-own-bundle-file-from-crt-files)


Answer: You may do this using you favorite text editor or by using the command line.

Example:

# Root CA Certificate - AddTrustExternalCARoot.crt
# Intermediate CA Certificate 1 - ComodoRSAAddTrustCA.crt OR ComodoECCAddTrustCA.crt
# Intermediate CA Certificate 2 - ComodoRSADomain/Organization/ExtendedvalidationSecureServerCA.crt OR ComodoRSAECCDomain/Organization/ExtendedvalidationSecureServerCA.crt
# Intermediate CA Certificate 3 - ComodoSHA256SecureServerCA.crt
# Your SSL Certificate - yourDomain.crt

Note: You will not need your SSL certificate for this exercise.

GUI Text Editor

1. Open All files in a text editor. (Remember, not your domain certificate.)
2. Create a new blank text file.
3. Copy contents of all files in reverse order and paste them into the new file.
   Example: Intermediate 3, Intermediate 2, Intermediate 1, Root Certificate.
4. Save newly created file as 'yourDomain.ca-bundle'.

Command Line

Linux or UNIX-like Operating Systems:
-- cat ComodoRSAAddTrustCA.crt ComodoRSADomain/Organization/ExtendedvalidationSecureServerCA.crt AddTrustExternalCARoot.crt > yourDomain.ca-bundle

Or

-- cat ComodoSHA256SecureServerCA.crt AddTrustExternalCARoot.crt > yourDomain.ca-bundle

Windows or DOS:
-- copy ComodoRSAAddTrustCA.crt + ComodoRSADomain/Organization/ExtendedvalidationSecureServerCA.crt + AddTrustExternalCARoot.crt yourDomain.ca-bundle

Or

-- copy ComodoSHA256SecureServerCA.crt + AddTrustExternalCARoot.crt yourDomain.ca-bundle

Note: 'yourDomain.ca-bundle' is only a place holder file name. You may call it anything you want.
