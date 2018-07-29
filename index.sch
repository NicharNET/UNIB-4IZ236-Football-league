<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <pattern id="check">
        <rule context="//teams/team">
            <assert test="count(players/player[@status='captain']) = 1">
                Exactly one player of the team has to be selected as the capitain.
            </assert>
        </rule>
    </pattern>
</schema>