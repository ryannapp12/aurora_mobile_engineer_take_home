String optimizeUnsplashSquare(String url, {int size = 1080}) {
  // Direct Unsplash, client-side crop via BoxFit; request compressed format.
  if (!url.contains('images.unsplash.com')) return url;
  final sep = url.contains('?') ? '&' : '?';
  return '$url${sep}auto=format&fit=crop&w=$size&h=$size&q=80';
}

String optimizeUnsplashSquarePreview(String url, {int size = 192}) {
  if (!url.contains('images.unsplash.com')) return url;
  final sep = url.contains('?') ? '&' : '?';
  return '$url${sep}auto=format&w=$size&q=20';
}