import 'package:flutter/material.dart';

// Represents a PDF book available in the free library
class PdfBook {
  final String id;
  final String title;
  final String? author; // Author might be optional
  final String assetPath; // Path to the PDF file in assets (e.g., 'assets/pdfs/book1.pdf')
  final String? coverImageUrl; // Optional path to a cover image asset

  PdfBook({
    required this.id,
    required this.title,
    this.author,
    required this.assetPath,
    this.coverImageUrl,
  });
}

