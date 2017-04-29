# BRUNO63/XSLFOTESTS

some tests with Apache FOP and WoD (World of Documents)

## helloworld

a simple helloworld example 
use this for an initial setup with the tool FOductivity.

## arbeitsrapport

example to generate a table with a calculated total.

## seeclub

generates yearly bills in different formats

- jahresrechnung:
  - re-generates the current invoice of the Seeclub (static, no ESR)
  - uses bk namespace
- invoiceEsr:
  - a newly styled invoice incl. ESR
  - open items
    - fonts are not correctly loaded
    - lib-esr2fo-2.0.xsl was left as is. Maybe its better to change it in order to optimize the data file.
    - correct positioning of the recipient address
    - red EZS with IBAN should be used
    - correct positioning of the recipient address
    - red EZS with IBAN should be used
