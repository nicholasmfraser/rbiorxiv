Dear CRAN maintainers,

This is a submission of a package removed for a policy violation received on 2021-02-15:

'Packages which use Internet resources should fail gracefully with an informative message
if the resource is not available or has changed (and not give a check warning nor error).'

The package maintainer was unable to react to the policy violation prior to the stated deadline on 2021-03-01.

This submission addresses the above violation and makes some additional minor improvements.

## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
> On windows-x86_64-devel (r-devel), ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Nicholas Fraser <nicholasmfraser@gmail.com>'
  
  New submission
  
  Package was archived on CRAN
  
  Possibly mis-spelled words in DESCRIPTION:
    preprints (9:29, 10:5)
  
  CRAN repository db overrides:
    X-CRAN-Comment: Archived on 2021-02-28 for policy violation.
  
    On Internet access.

0 errors √ | 0 warnings √ | 1 note x

- The note refers to a mis-spelled word ("preprints") which has been checked and is correctly spelled.


