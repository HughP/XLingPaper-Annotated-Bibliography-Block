# XLingPaper Annotated Bibliography Proposal
## Prose
The goal is to be able to insert a “block” in XLingPaper and to have that block cycle through the references in a document or its “references linked document portion” creating the citation refs needed to create an annotated bibliography. The great advantage of this would be the ability to rapidly process hundreds of citations into an annotated bibliography based on some criteria — such as a keyword attached to the citation. An external tool like Zotero can be leveraged then for collaborative management of annotations and citation data. Existing import processes can be leveraged and XLingPaper can be used to produce nice clean annotated bibliographies.
### The challenge
Andy points out that creating sub-units within XML/XSL is possible, but is a challenge. By sub-units I mean something like the following with keywords: Keywords to include ("additive" and "or" logic e.g. `Education`, `Nepal` could be based on a second entity, `Education+Nepal or Education||Nepal` ) — I'm not sure how to describe `(Education+Nepal)||Tibet`, which is different from `Education+(Nepal||Tibet)`;
### This repo

* you will find the current data file in `MakeAnnReal/Sample-Document.xml` you will find the transform we have started here `MakeAnnReal.xsl`.

## Existing XLingPaper Code
The following two cases are what the current code looks like for annotated bibliographies in XLingPaper. 
### Case — Simple
```XML
<annotationRef annotation="atNote" citation="rdeCharenceyHyacinthe1862LesDi"></annotationRef>

```
### Case — Complex
```XML
<annotationRef XeLaTeXSpecial="some" annotation="atNote" citation="rdeCharenceyHyacinthe1862LesDi" cssSpecial="some2" xsl-foSpecial="some3"></annotationRef>

```

## Proposed XLingPaper Code
The annotation block element provides all the attributes necessary for generating the annotation references needed for further processing.

### Case — AnnotationBlock
```XML
<annotatedBibliographySection id="" excludeKeywords="" includeKeywords="" excludeLanguages="" includeLanguages="" excludeTypes="" includeTypes="" languageKeywordInteraction="additive||filter1||filter2" annotationType="" sortOrder="asc||dec||appearance" sortElement="pubDate||author||type||accessDate" numberEntries="false||perDocument||perSection||manual" startNumber=""></annotatedBibliographySection>

```
