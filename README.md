# UNIB-4IZ236-Football-league

[![codebeat badge](https://codebeat.co/badges/fb32e12d-6a48-452b-a24b-327918bf1aa1)](https://codebeat.co/projects/github-com-nicharnet-unib-4iz236-football-league-master)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/50efc37159ae46579add55cda74e44e7)](https://www.codacy.com/app/NicharNET/UNIB-4IZ236-Football-league?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=NicharNET/UNIB-4IZ236-Football-league&amp;utm_campaign=Badge_Grade)
[![GitHub](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/NicharNET/UNIB-4IZ236-Football-league/blob/master/LICENSE)

XSLT transformation to both HTML and PDF applied on a XML file with football league data

### [https://nicharnet.github.io/UNIB-4IZ236-Football-league/](https://nicharnet.github.io/UNIB-4IZ236-Football-league/)

This is also my very first XSLT transformation to both HTML and PDF from 2016 and published now.

## Input

The only input is a  XML file.

### [index.xml](https://github.com/NicharNET/UNIB-4IZ236-Football-league/blob/master/index.html)

It's the input XML file with a root element `league` and two its descendants `detail` describing the league detail and `teams` which lists the detailed description of the team itself and all its players. A brief form appears below:

```XML
<league>
    <detail>
        <!--/* League details */ -->
    </detail>
    <teams>
        <team>
            <description>
                <!--/* Team description */ -->
            </description>
            <players>
                <player>
                    <!--/* Player description */ -->
                </player>
                <!--/* Another player */ -->
        </team>
        <!--/* Another team */ -->
    </teams>
</league>
```
## Validation

The only input XML file validated against both a XSD file and a Schematron file.

### [index.xsd](https://github.com/NicharNET/UNIB-4IZ236-Football-league/blob/master/index.xsd)

This XSD file is a crucial validation file for the input XML which validates its entire structure, the allowed count and order of the particular elements and the data type and format of their values. The following list provides a selection of the most important rules (not ordered by the importance):

 - A
 - B
 - C

### [index.sch](https://github.com/NicharNET/UNIB-4IZ236-Football-league/blob/master/index.sch)

The Schematron validation is a minor and a supplementary validation file using XPath. Its only job is to assure that each team will have only and exactly one player market as a captain. A part of the overall score was the usage of a Schematron file and the captain validation is a job which suits Schematron a lot:

```XML
<pattern id="check">
    <rule context="//teams/team">
        <assert test="count(players/player[@status='captain']) = 1">
            <!-- Error message -->
        </assert>
    </rule>
</pattern>
```

## Transformation

## Ouptut

### HTML

### PDF

## Quality check
I have integrated Codebeat and Codacy cloud static analysis services to check the overall code quality out of curiosity.

## Licence

MIT License

Copyright (c) 2018 Nikolas Charalambidis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
