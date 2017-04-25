# VODKA
## Viral Open-source DVG Key Algorithm

### Usage

    VODKA --genomeFA <input fasta> --queryInput <file of fastq/fasta> --outDir <output directory> \
    --bt2Dir <bowtie2 directory> --webLogo <webLogo> [options]

* --genomeFA &lt;input fasta> : viral genome fasta file.
* --queryInput &lt;fastq/fastq> : a file with full path of fastq or fasta files for alignment. fastq/fasta files can be gzip'ed.
* --outDir &lt;output directory> : full path to output directory.
* --bt2Dir &lt;bowtie2 directory> : full path to bowtie2-2.2.9 directory. (where bowtie2 and bowtie2-build is located)
* --webLogo &lt;webLogo> : full path to webLogo.

* options : <br>
    * -bp_from_right &lt;n> : &lt;n> is number of bases from right. (default: 3000)
    * -h/--help : print this usage.

### Requirements
* bowtie2-2.2.9: Download bowtie2-2.2.9 from [here.](https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.9)
* webLogo: Download webLogo (version 3.5) from [here.](https://github.com/WebLogo/weblogo)
* RAM: 2.5G per fastq/fasta file (for reads longer than 150bp, 3G per fastq/fasta). 

