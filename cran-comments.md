## Resubmission

Addresses CRAN reviewer commments:

* DESCRIPTION:
  * Put single quotes around API and function names
  * Added web reference for OpenAI API
* Add return value documentation for:
  * delete_keyring_credentials()
  * set_key()
  * set_model()
* Uncommented example code for whatis() function

### Remote R CMD check results

```text
0 errors | 0 warnings | 1 note
```

Finds "(possibly) invalid URLs" in the README that require logging into OpenAI's website. Instructions above those URLs indicate how to create an account with OpenAI.

## Initial Submission

* This is a new release.
* Exported functions largely produce side-effects and doc examples should not be run.
* Tests verify the exported functions across Unix, MacOS, Windows.

### Local R CMD check results

0 errors | 0 warnings | 0 note
