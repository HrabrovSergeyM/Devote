//
//  ContentView.swift
//  Devote
//
//  Created by Sergey Hrabrov on 17.07.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - Properties
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    // MARK: - Functions
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Main View
                VStack {
                    // MARK: - Header
                    HStack(spacing: 10) {
                    // Title
                        
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        
                        Spacer()
                        
                        // Edit Button
                        
                        if !items.isEmpty {
                            EditButton()
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .padding(.horizontal, 10)
                                .frame(minWidth: 70, minHeight: 24)
                                .background(Capsule().stroke(Color.white, lineWidth: 2))
                        } 
                        
                        // Theme Change Button
                        
                        Button {
                            isDarkMode.toggle()
                        } label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        }

                        
                        
                    } // HStack
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 80)
                    
                    // MARK: - New Task
                    
                    Button {
                        showNewTaskItem = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.pink, .blue]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                    )
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
                    
                    // MARK: - Tasks
                    
                    if items.isEmpty {
                        Color.clear
                    } else {
                        List {
                            ForEach(items) { item in
                               ListRowItemView(item: item)
                            } // ForEach
                            .onDelete(perform: deleteItems)
                        } // List
                        .scrollContentBackground(.hidden)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                        .padding(.vertical, 0)
                        .frame(maxWidth: 640)
                    } // if/else
                } // VStack
                .blur(radius: showNewTaskItem ? 8.0 : 0.0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5), value: showNewTaskItem)
                // MARK: - New Task Item
                
                if showNewTaskItem {
                    BlankView(
                        backgroundColor: isDarkMode ? .black : .gray,
                        backgroundOpacity: isDarkMode ? 0.3 : 0.5)
                        .onTapGesture {
                            withAnimation() {
                                showNewTaskItem = false
                            }
                        }
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
                
            } // ZStack
            .toolbar(.hidden, for: .navigationBar)
            .background(
                BackgroundImageView().blur(radius: showNewTaskItem ? 8.0 : 0.0, opaque: false)
            )
            .navigationTitle("Daily Tasks")
            .navigationBarTitleDisplayMode(.large)
            .background(backgroundGradient.ignoresSafeArea())
        } // NavigationView
        
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
