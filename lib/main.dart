import 'package:dicoding_news_app/components/fonts.dart';
import 'package:dicoding_news_app/components/style.dart';
import 'package:dicoding_news_app/model/article.dart';
import 'package:dicoding_news_app/screens/detail_page.dart';
import 'package:dicoding_news_app/screens/webview_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App Dicoding',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)))),
        ),
        appBarTheme: const AppBarTheme(elevation: 0),
        textTheme: myTextTheme,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
              onPrimary: Colors.black,
              secondary: secondaryColor,
            ),
      ),
      initialRoute: NewListPage.routeName,
      routes: {
        NewListPage.routeName: (context) => const NewListPage(),
        ArticleDetailPage.routeName: (context) => ArticleDetailPage(
              article: ModalRoute.of(context)?.settings.arguments as Article,
            ),
        ArticleWebView.routeName: (context) => ArticleWebView(
              url: ModalRoute.of(context)?.settings.arguments as String,
            ),
      },
    );
  }
}

class NewListPage extends StatelessWidget {
  static const routeName = '/article_list';
  const NewListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: FutureBuilder<String>(
        future:
            DefaultAssetBundle.of(context).loadString('assets/articles.json'),
        builder: (context, snapshot) {
          final List<Article> articles = parseArticles(snapshot.data);
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return _buildArticleItem(context, articles[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildArticleItem(BuildContext context, Article articles) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      leading: Hero(
        tag: articles.urlToImage,
        child: Image.network(
          articles.urlToImage,
          width: 100,
          errorBuilder: (context, error, _) {
            return const Center(
              child: Icon(Icons.error),
            );
          },
        ),
      ),
      title: Text(articles.title),
      subtitle: Text(articles.author),
      onTap: () {
        Navigator.pushNamed(context, ArticleDetailPage.routeName,
            arguments: articles);
      },
    );
  }
}
