\name{hg38.101.txdb}
\docType{package}

\alias{hg38.101.txdb-package}
\alias{hg38.101.txdb}
\alias{hg38.101.txdb}


\title{Annotation package for TxDb object(s)}

\description{  
  This package loads one or more TxDb objects.  Such TxDb
  objects are an R interface to prefabricated databases contained by
  this package.

  The names of any objects exposed by this package indicate the origin and
  resources exposed.  So for example TxDb.Hsapiens.UCSC.hg19.knownGene
  would be a TxDb object, of Homo sapiens data from UCSC build
  hg19 based on the knownGene Track.
}

\note{
  This data package was made from resources at UCSC on
  2015-10-07 18:11:28 +0000 (Wed, 07 Oct 2015) and based on the hg19 genome based on the knownGene table
}

\author{czh, <test@163.com> [cre]}


\seealso{
  \link[GenomicFeatures]{transcripts},
  \link[GenomicFeatures]{transcriptsBy}
}

\examples{
## load the library
library(hg38.101.txdb)
## list the contents that are loaded into memory
ls('package:hg38.101.txdb')
## show the db object that is loaded by calling it's name
hg38.101.txdb

}

\keyword{package}
\keyword{data}
