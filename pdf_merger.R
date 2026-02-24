# ==========================================
# Script Name: PDF Standardiser & Merger
# Description: Combines all PDFs in a directory, standardizes formatting, 
#              and removes a specific page (e.g., a generic cover).
# Date: 2026-02-24
# Dependencies: pdftools, qpdf
# License: MIT
# ==========================================

# Load required libraries
if (!require("pdftools")) install.packages("pdftools")
if (!require("qpdf")) install.packages("qpdf")

library(pdftools)
library(qpdf)

# --- Configuration ---
# Using "." means it will look into the folder where your script/project is located.
# This works seamlessly on both Windows and macOS.
input_dir <- getwd() 

output_filename <- "Standardised_Combined.pdf"
temp_filename   <- "temp_full_merge.pdf"
temp_folder_name <- "temp_resized_folder"

output_final  <- file.path(input_dir, output_filename)
temp_combined <- file.path(input_dir, temp_filename)
temp_dir      <- file.path(input_dir, temp_folder_name)

# --- File Preparation ---
# Get all PDF files, ensuring case-insensitivity
files <- list.files(path = input_dir, pattern = "(?i)\\.pdf$", full.names = TRUE)

# Exclude existing output files to prevent infinite loops
files <- files[!grepl(paste0(output_filename, "|", temp_filename), files)]
files <- sort(files)

if (length(files) == 0) {
  stop("No PDF files found in the directory: ", input_dir)
}

# --- Processing ---
if (!dir.exists(temp_dir)) dir.create(temp_dir)

standardised_list <- c()

message("Processing ", length(files), " files...")

for (i in seq_along(files)) {
  out_path <- file.path(temp_dir, paste0("std_", i, ".pdf"))
  
  # Standardise by subsetting all pages (ensures qpdf compatibility)
  n_pages <- pdf_info(files[i])$pages
  pdf_subset(files[i], pages = 1:n_pages, output = out_path)
  
  standardised_list <- c(standardised_list, out_path)
}

# Combine all processed files
pdf_combine(standardised_list, output = temp_combined)

# --- Custom Modification ---
# Example: Remove page 3 from the final merged document
total_pages <- pdf_info(temp_combined)$pages
page_to_remove <- 3

if (total_pages >= page_to_remove) {
  pages_to_keep <- setdiff(1:total_pages, page_to_remove)
  pdf_subset(temp_combined, pages = pages_to_keep, output = output_final)
  message("Success! Page ", page_to_remove, " removed.")
} else {
  file.copy(temp_combined, output_final)
  warning("Page to remove (", page_to_remove, ") exceeds total pages. Merged without removal.")
}

# --- Cleanup ---
unlink(temp_dir, recursive = TRUE)
if (file.exists(temp_combined)) file.remove(temp_combined)

message("Final file saved at: ", output_final)
