import 'package:flutter/cupertino.dart'; // Importiert Cupertino-spezifische Widgets (iOS-Stil)
import 'package:flutter/material.dart'; // Importiert die Material Design Widgets

class ResponsiveButton extends StatelessWidget { // Definiert ein benutzerdefiniertes stateless Widget namens ResponsiveButton
  final bool? isResponsive; // Optionale Variable, ob der Button responsiv ist
  final double? width; // Optionale Breite des Buttons
  final VoidCallback? onTap; // Callback-Funktion, die beim Tippen ausgeführt wird

  const ResponsiveButton({
    super.key,
    this.width = 150, // Standardbreite ist 150
    this.isResponsive = false, // Standardmäßig nicht responsiv
    this.onTap, // Übergabe der onTap-Funktion
  }); // Übergibt den Schlüssel an die Oberklasse

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Widget zur Erkennung von Gesten (z. B. Tippen)
      onTap: onTap, // Führt die übergebene Funktion aus, wenn der Button getippt wird
      child: Container( // Container als visuelles Element des Buttons
        width: width, // Setzt die Breite
        height: 60, // Feste Höhe des Buttons
        decoration: BoxDecoration( // Visuelles Styling
          borderRadius: BorderRadius.circular(15), // Abgerundete Ecken
          color: const Color(0x80FFFFFF), // 0x80 = 50% opacity σε hex
          border: Border.all( // Weißer Rand mit Transparenz
            color: const Color(0x80FFFFFF), // 0x80 = 50% opacity σε hex
            width: 1.5,
          ),
        ),
        child: Center( // Zentriert das Kind innerhalb des Containers
          child: Image.asset(
            "img/button-one.png", // Pfad zum Bild, das im Button angezeigt wird
            height: 30, // Bildhöhe
            fit: BoxFit.contain, // Bild wird skaliert, ohne das Seitenverhältnis zu verlieren
          ),
        ),
      ),
    );
  }
}

