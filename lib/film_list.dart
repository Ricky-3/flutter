import 'package:flutter/material.dart';

class FilmList extends StatelessWidget {
  final List<dynamic>? films;
  final List<String>? filmImages;

  const FilmList({Key? key, required this.films, required this.filmImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: films?.length ?? 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(filmImages![index], width: 160, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 8),
                Text(films![index]['title'] ?? '', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('${films![index]['release_date'] ?? ''}', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}
