## rbiorxiv 0.2.2

### Minor changes:

* Fixed failing test due to new "jatsxml" column returned from "details" API endpoint

## rbiorxiv 0.2.1

### Minor changes:

* Improved response and request handling. `httr::GET` is replaced by `httr::RETRY`, for automatic retries on failing API requests. On some occassions API requests were failing with the error message "Error : (2002) Connection refused", usually when the server was too busy - these requests now fail gracefully with an informative error message.
* Added a 1-second sleep function between each API call to reduce stress on server.
* Added functionality for checking internet connection prior to attempting API calls.
* Fixed issue where some iterative queries were failing due to a mismatch between the number of records the bioRxiv API estimated versus the number of actual records.

## rbiorxiv 0.2.0

### NEW FEATURES

* Initial version for CRAN submission
