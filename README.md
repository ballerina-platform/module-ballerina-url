Ballerina URL Library
===================

  [![Build](https://github.com/ballerina-platform/module-ballerina-url/actions/workflows/build-timestamped-master.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerina-url/actions/workflows/build-timestamped-master.yml)
  [![codecov](https://codecov.io/gh/ballerina-platform/module-ballerina-url/branch/master/graph/badge.svg)](https://codecov.io/gh/ballerina-platform/module-ballerina-url)
  [![Trivy](https://github.com/ballerina-platform/module-ballerina-url/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerina-url/actions/workflows/trivy-scan.yml)
  [![GraalVM Check](https://github.com/ballerina-platform/module-ballerina-url/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerina-url/actions/workflows/build-with-bal-test-graalvm.yml)
  [![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerina-url.svg?label=Last%20Commit)](https://github.com/ballerina-platform/module-ballerina-url/commits/master)
  [![GitHub issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-standard-library/module/url.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-standard-library/labels/module%2Furl)

This library provides the URL encoding/decoding functions.

URL encoding stands for encoding certain characters in a URL by replacing them with one or more character triplets that consist of the percent character `%` followed by two hexadecimal digits. The two hexadecimal digits of the triplet(s) represent the numeric value of the replaced character.

The Ballerina `url` library facilitates APIs to encode and decode a URL or part of a URL.

## Issues and projects

Issues and Projects tabs are disabled for this repository as this is part of the Ballerina Standard Library. To report bugs, request new features, start new discussions, view project boards, etc., go to the [Ballerina Standard Library parent repository](https://github.com/ballerina-platform/ballerina-standard-library).

This repository only contains the source code for the module.

## Build from the source

### Set up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 11 (from one of the following locations).

   * [Oracle](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html)
   
   * [OpenJDK](https://adoptium.net)
   
        > **Note:** Set the `JAVA_HOME` environment variable to the path name of the directory into which you installed JDK.

2. Export your GitHub Personal Access Token (PAT) with the 'read package' permission as follows:

    ```
    export packageUser=<Username>
    export packagePAT=<Personal Access Token>
    ```

### Build the source

Execute the commands below to build from the source.

1. To build the package:
    ```    
    ./gradlew clean build
    ```
2. To run the tests:
    ```
    ./gradlew clean test
    ```

3. To run a group of tests
    ```
    ./gradlew clean test -Pgroups=<test_group_names>
    ```

4. To build the without the tests:
    ```
    ./gradlew clean build -x test
    ```

5. To debug package implementation:
    ```
    ./gradlew clean build -Pdebug=<port>
    ```

6. To debug with Ballerina language:
    ```
    ./gradlew clean build -PbalJavaDebug=<port>
    ```

7. Publish the generated artifacts to the local Ballerina central repository:
    ```
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina central repository:
    ```
    ./gradlew clean build -PpublishToCentral=true
    ```

## Contribute to Ballerina

As an open source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`url` library](https://lib.ballerina.io/ballerina/url/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
