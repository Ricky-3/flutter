import 'package:flutter/material.dart';

class SerieList extends StatelessWidget {
  final List<dynamic>? series;
  final List<String>? serieImages;

  SerieList({required this.series, required this.serieImages});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var index = 0; index < (series?.length ?? 0); index++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(serieImages![index], width: 160, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(series![index]['name'] ?? '', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('${series![index]['first_air_date'] ?? ''}', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
