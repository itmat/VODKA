
#Suppress warning messages for duration of the script
oldw <- getOption("warn")
options(warn = -1)

pkgTest <- function(x)
  {
    if (!require(x,character.only = TRUE))
    {
      install.packages(x,dep=TRUE)
        if(!require(x,character.only = TRUE)) stop("Package not found")
    }
  }
pkgTest("Biostrings")

suppressPackageStartupMessages(library(Biostrings, quietly = TRUE))

#Read and process command-line arguments for this script:
args = commandArgs(TRUE)
aclist = args[1]
loc = args[2]

fileName = paste(loc, aclist, sep="/")
lines <-readLines(fileName)
for (i in 1:length(lines)){
   name=lines[i]
   tfasta = paste(name,"mapped.fasta",sep=".")
   tref = paste("REF",name,"fasta",sep=".")
   fastaFile = paste(loc, tfasta, sep="/")
   refFile = paste(loc, tref, sep="/")
   seq<-readDNAStringSet(fastaFile)
   ref<-readDNAStringSet(refFile)
   overlap<-pairwiseAlignment(pattern=seq,subject=ref,type="overlap")
   aln<-aligned(overlap)
   seqlist<-as.character(aln)
   tseqlist=paste("for_logo",name,"fasta",sep=".")
   seqlistFile=paste(loc,tseqlist,sep="/")
   if (file.exists(seqlistFile)) file.remove(seqlistFile)
   for (i in 1:length(seqlist)){
       sid=paste(">seq",i,sep="")
       sequence=seqlist[i]
       cat(sid,sep="\n",file=seqlistFile,append=TRUE)
       cat(sequence,sep="\n",file=seqlistFile,append=TRUE)
   }
}
string="got here"
cat(string)