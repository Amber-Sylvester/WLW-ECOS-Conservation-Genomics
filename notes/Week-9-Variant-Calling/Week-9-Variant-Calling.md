Variant calling is the process of identifying differences in DNA sequences by examining sequencing reads that have been aligned to a reference genome.

1. Reads (FASTQ): Raw sequencing reads contain DNA sequences and their associated quality scores.

2. Alignment (BAM): Reads are mapped to a reference genome. The resulting BAM file stores the aligned reads and their genomic locations.

3. Variant caller: A program examines the aligned reads to identify positions where the observed DNA differs from the reference genome.

4. Genotypes / genotype likelihoods: The program estimates which alleles an individual carries. Genotype likelihoods account for uncertainty caused by sequencing and mapping errors.

5. VCF: The Variant Call Format file stores identified variants, their genomic positions, reference and alternative alleles, quality information, and genotypes for individual samples.

Variant calling can be challenging in non-model organisms because they may have incomplete reference genomes and limited existing genome information. This makes it harder to accurately align reads and distinguish real genetic differences from sequencing or mapping errors. Coral samples can also contain DNA from symbiotic algae and other microorganisms, which adds complexity when analyzing the coral host's genome. Low sequencing coverage and uncertainty in genotype estimates can further affect the accuracy of variant calls. Careful quality control, read alignment, variant filtering, and genotype likelihood estimation are important for producing reliable results.
