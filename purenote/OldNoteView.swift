//
//  NoteView.swift
//  purenote
//
//  Created by Saša Mitrović on 15.10.20.
//

import SwiftUI
import Parma

struct OldNoteView: View {
    @EnvironmentObject var data: DataManager
    @EnvironmentObject var index : SearchIndex
    @State private var showEditView = true
    var isSearching = false
    
    @State var showingDirectoryPicker = false
    
    @State var noteToMove = Note(type: .Note)
    
    var body: some View {
        
        ForEach(data.notes) { note in
            
            VStack {
                
                NavigationLink(destination:
//                                ScrollView {
                                   
                                VStack {
                                    NoteEdit(note: note)
    //                                            .frame(maxWidth: .infinity, alignment: .topLeading)
    //                                            .padding(.leading, 5.0)
                                                .showIf(condition: showEditView)
                                        .environmentObject(data)
                                }
                                            
                               
//                                        Parma(note.content, render: MyRender())
//
//                                            .gesture(
//                                                TapGesture()
//                                                    .onEnded { _ in
//                                                        showEditView.toggle()
//                                                    }
//                                            )
//                                            .frame(maxWidth: .infinity, alignment: .topLeading)
//                                            .padding(.leading, 5.0)
//                                            .navigationBarItems(trailing:  Button(action: {
//                                                showEditView.toggle()
//
//                                            }) {
//                                                Text("Edit").font(.title2).foregroundColor(Color(UIColor.systemOrange))
//                                            }
//                                            //                                        .sheet(isPresented: $showEditView) {
//                                            //
//                                            //                                            NoteEdit(note: note, showSheetView: $showEditView)
//                                            //                                                .environmentObject(data)
//                                            //
//                                            //                                        }
//                                            )
//                                            .showIf(condition: !showEditView)
//                                            .environmentObject(self.data)
                                    
                                    
                                    
//                                }
                ) {
                    ListRow(note: note).environmentObject(self.data)
                }
                
                .contextMenu {
                    Button(action: {
                        noteToMove = note
                        showingDirectoryPicker.toggle()
                    }) {
                        Text("Move Note")
                        Image(systemName: "folder")
                    }
                }
                .sheet(isPresented: $showingDirectoryPicker) {
                    
                    DocumentPickerViewController  { url in
                        
                        let newNoteUrl : URL = url.appendingPathComponent(note.id)
                        
                        do {
                            try FileManager.default.moveItem(at: noteToMove.url, to: newNoteUrl)
                        }
                        catch {
                            // failed
                            print("Failed to move file: \(error).")
                        }
                        
                        data.refresh(url: data.getCurrentUrl())
                    }
                    
                }
                .showIf(condition: note.isLocal)
                
                
                ICloudItemView(note : note)
                    .environmentObject(self.data)
                    .environmentObject(self.index)
                    .frame(maxWidth: .infinity, alignment: .leading).showIf(condition: !note.isLocal)
            }
            
            
        }
        
        
        .onDelete(perform: deleteItems).padding(.leading, 5.0)
        
        
        VStack {
            HStack {
                Text("Tap the")
                Image(systemName: "square.and.pencil")
                Text("button to create a new note")
            }.placeholderForegroundColor()
        }.showIf(condition: data.notes.count == 0 && !isSearching)
    }
    
    // how to return HStack or VStack as a view
    // https://stackoverflow.com/a/59663108/1393362
    
    
    func deleteItems(at offsets: IndexSet) {
        
        for offset in offsets.enumerated() {
            do {
                try FileManager.default.trashItem(at: data.notes[offset.element].url, resultingItemURL: nil)
            }
            catch {
                // failed
                print("Failed to delete notes: \(error).")
            }
            
        }
        data.notes.remove(atOffsets: offsets)
        index.indexall()
        
    }
}

struct OldNoteView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            OldNoteView()
                .environmentObject(DataManager.sampleDataManager())
                .environmentObject(SearchIndex.init(rootUrl: URL(fileURLWithPath: "/")))
        }
        
    }
}

//struct MyRender: ParmaRenderable {
//    
//    public func  paragraphBlock(view: AnyView) -> AnyView {
//        return AnyView(
//            VStack(alignment: .leading) {
//                view
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.top, 4)
//            })
//        
//        
//    }
//    
//    //    func heading(level: HeadingLevel?, textView: Text) -> Text {
//    //        switch level {
//    //        case .one:
//    //            return textView.font(.system(.largeTitle, design: .serif)).bold()
//    //        case .two:
//    //            return textView.font(.system(.title, design: .serif)).bold()
//    //        case .three:
//    //            return textView.font(.system(.title2)).bold()
//    //        default:
//    //            return textView.font(.system(.title3)).bold()
//    //        }
//    //    }
//    
//    func headingBlock(level: HeadingLevel?, view: AnyView) -> AnyView {
//        switch level {
//        case .one, .two:
//            return AnyView(
//                VStack(alignment: .leading, spacing: 2) {
//                    view
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.top, 4)
//                }
//            )
//        default:
//            return AnyView(view.padding(.bottom, 4)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//            )
//        }
//    }
//    
//    
//    
//    //    func listItem(view: AnyView) -> AnyView {
//    //        let bullet = "•"
//    //        return AnyView(
//    //            VStack(alignment: .leading) {
//    //                HStack(alignment: .top, spacing: 8) {
//    //                    Text(bullet).frame(alignment: .leading)
//    //                    view
//    //                        .frame(maxWidth: .infinity, alignment: .leading)
//    //                        .fixedSize(horizontal: false, vertical: true)
//    //                }
//    //                .padding(.leading, 4)
//    //            }
//    //        )
//    //    }
//}