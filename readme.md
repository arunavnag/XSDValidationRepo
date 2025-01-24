Prequisites:

* git
* nodejs (16+)

Prepare:

`npm install -g`

Then clone all dependant repositories (check site.yml for urls) into the same root folder next to this repository

NOTE:
To build the UI, use `https://github.com/bosch-semantic-stack/rbs-antora-ui` repository from RBS team. In there is an integration guide branch with the current version of this theme.
After it is build, it needs to be placed (as .zip) into the `/docs-ui/` folder.

## How to build locally:

## manually
in this folder, run 

`antora site-local.yml --stacktrace; `

To copy the index html and other files to exchange the overview page

(Powershell)
`Copy-Item -force -Recurse -Path src\docs\html\* -Destination build\site\`

(bash)
`cp -f -r src/docs/html/* build/site/`


## comfortably 

``` 
.\generate.ps1 [-serve] [-fetch] [-help] [siteFile]
```
serve
 : start a webserver to display the result (needed to view API doc), requires `http-server` to be installed globally in npm

fetch
 : fetch the latest versions from repositories (by default antora does not update this often)

help
 : display help

siteFile
 : the file you want to build - defaults to `site.yml`. Recommendation is to copy `site.yml` to `site-local.yml` and reference documentation you are actively modifying via local path.

## How to build remotely:

To make use of the automatic build and deployment pipeline (https://dev.azure.com/bosch-bci/Nx_Foundation/_build?definitionId=5482), just create a new branch from master, commit your changes and push them.

The pipeline will trigger automatically on any changes in the repository and publish the result in a separate URL in the scheme `https://delightful-pond-0b8657103-<<BranchName>>.westeurope.5.azurestaticapps.net`.
If you are unsure about the URL, check the pipeline logs at the end of the "DEV" -> "AzureStaticWebApp"-step.
example:  https://delightful-pond-0b8657103-dev.westeurope.5.azurestaticapps.net

ATTENTION!! every sunday, a job clears all static web app instances beside "dev" and "master"

## How to add a new module/repository:

1. add the repo info as "content source" into site.yaml and site-local.yaml
2. add the module ID in site.yaml central navigation declaration (search for "page-component-sort-order")
3. optional: update building blocks page
4. update root overview page (src/docs/modules/ROOT/pages/index.adoc)
   - if your ART is not yet present, introduce a new section
   - you can use all currently available Bosch Icons like in WebCore ("bosch-ic-" prefix)
5. update changelog adoc (src/docs/modules/changelog/pages/changelog.adoc)

## How to release:

### If you have made changes to any related resources (-> Antora pulls them)

1. trigger the [integration guide pipeline](https://dev.azure.com/bosch-bci/Nx_Foundation/_build?definitionId=7087) on the master branch
2. master triggers a pre-release build that runs a link checking tool to hunt for broken links and creates a new branch under the `/release-request/<<Build_Number>>` path, commits the new files and pushes the changes
3. the pipeline automatically creates a pull request from the new branch into the `release` branch and assigns reviewers. Output of the antora stdout/err are in the description. The release branch only includes the built artefacts, so a PR will highlight the changed HTML etc. files. [Release PRs](https://dev.azure.com/bosch-bci/Nx_Foundation/_git/integration-guide/pullrequests?_a=active&targetRefName=refs/heads/release)
4. when the PR is completed, the [pipeline of the release branch](https://dev.azure.com/bosch-bci/Nx_Foundation/_build?definitionId=7088) deploys the new build onto the main [production space of the static web app](https://docs.bosch-nexeed.com/)


### If you have made changes to the integration guide via a separate integration guide branch:
1. create a pull request. Daniel Dreyer or a proxy is added as reviewer
    - the PR pipeline will do a pre-merge build to check the result of the changes
    - the merge branch is https://delightful-pond-0b8657103-merge.westeurope.5.azurestaticapps.net
2. if the PR is reviewed and accepted, changes will be merged to master
3. see points from 2 on above

