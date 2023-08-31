import 'package:firebase_app/models/note_model.dart';
import 'package:firebase_app/repositories/firebase_note_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _noteBodyTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent.withOpacity(0.5),
          foregroundColor: Colors.blueAccent.withOpacity(0.8),
          elevation: 0,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                padding: const EdgeInsets.all(12.0),
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    const Text("Write a note",
                        style: TextStyle(fontSize: 40.0)),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: _titleTextEditingController,
                      decoration: const InputDecoration(
                        hintText: "Tite of the note",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: _noteBodyTextEditingController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: "Note Text",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStatePropertyAll(0),
                        backgroundColor: MaterialStatePropertyAll(
                          Colors.blueAccent.withOpacity(0.8),
                        ),
                      ),
                      onPressed: () => FirebaseNoteRepo.saveNote(NoteModel(
                          id: "00",
                          text: _noteBodyTextEditingController.text,
                          title: _titleTextEditingController.text)),
                      child: Text(
                        "Save Note",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: FirebaseNoteRepo.getNotes(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Has Error"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text("Loading Data"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(15.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data?[index].title ?? "no title",
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          Text(
                            snapshot.data?[index].text ?? "no text",
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _titleTextEditingController.text =
                                  snapshot.data?[index].title ?? "no title";
                              _noteBodyTextEditingController.text =
                                  snapshot.data?[index].text ?? "no text";
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  padding: const EdgeInsets.all(12.0),
                                  width: double.infinity,
                                  height: 600.0,
                                  child: Column(
                                    children: [
                                      const Text("Edit this note",
                                          style: TextStyle(fontSize: 40.0)),
                                      const SizedBox(height: 12.0),
                                      TextField(
                                        controller: _titleTextEditingController,
                                        decoration: const InputDecoration(
                                          hintText: "Tite of the note",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                      TextField(
                                        controller:
                                            _noteBodyTextEditingController,
                                        maxLines: 5,
                                        decoration: const InputDecoration(
                                          hintText: "Note Text",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                      ElevatedButton(
                                        onPressed: () =>
                                            FirebaseNoteRepo.updateNote(
                                          NoteModel(
                                              id: snapshot.data![index].id,
                                              text:
                                                  _noteBodyTextEditingController
                                                      .text,
                                              title: _titleTextEditingController
                                                  .text),
                                        ),
                                        child: const Text("Save Changes"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => FirebaseNoteRepo.deleteNote(
                                snapshot.data![index]),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        ));
  }
}
