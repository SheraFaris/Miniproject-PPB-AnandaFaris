//import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trial1/gamelist/firestore.dart';
import 'package:trial1/pages/yolo_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // firestore
  final FirestoreService firestoreService = FirestoreService();
  
  // text controller
  final TextEditingController textController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // Open a dialog box to add a note
  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // text user input
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // add new note
              if (docID == null){
                firestoreService.addNote(textController.text); 
              }

              //update existing note
              else {
                firestoreService.updateNote(docID, textController.text);
              }

              // clear the text controller
              textController.clear();

              // Close the box 
              Navigator.pop(context);
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Open YOLO page',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const YOLODetection(),
              ),
            );
          },
          icon: const Icon(Icons.camera_alt_outlined),
        ),
        title: Text(
          'LOGGED IN AS: ${user.email!}',
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: signUserOut, 
            icon: Icon(Icons.logout),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ), 
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNoteStream() ,
        builder: (context, snapshot) {

          // If data exists, get all data
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            // Display as a List
            return Column(
              children: [
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final uri = Uri.parse('https://steamdb.info/stats/gameratings/');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not open the URL')),
                      );
                    }
                  },
                  child: const Text('Open SteamDB gameratings'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: notesList.length,
                    itemBuilder: (context, index){
                      // Get indv doc
                      DocumentSnapshot document = notesList[index];
                      String docID = document.id;
                  
                      // Get note on each doc
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      final String noteText = data['note'] ?? '';
                  
                      // Display as a list tile
                      return ListTile(
                        title: Text(noteText),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //update
                            IconButton(
                              onPressed: () => openNoteBox(docID: docID), 
                              icon: const Icon(Icons.settings),
                            ),
                  
                            //Delete
                            IconButton(
                              onPressed: () => firestoreService.deleteNote(docID), 
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          // if there is no notes
          else {
            return const Text('No notes'); 
            /*Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
            

                ],
              )
            );*/
          }
        }
      )
    );
  }
}