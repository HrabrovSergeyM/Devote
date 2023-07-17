//
//  NewTaskItemView.swift
//  Devote
//
//  Created by Sergey Hrabrov on 17.07.2023.
//

import SwiftUI

struct NewTaskItemView: View {
    // MARK: - Properties
    
    @State private var task: String = ""
    
    @FocusState private var taskIsFocused: Bool
    
    @Environment(\.managedObjectContext) private  var viewContext
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    // MARK: - Functions

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
            
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
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                TextField("New Task", text: $task)
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(
                        Color(UIColor.systemGray6)
                    )
                    .cornerRadius(10)
                    .focused($taskIsFocused)
                
                Button {
                    addItem()
                    taskIsFocused = false
                } label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                }
                .disabled(isButtonDisabled)
                .padding()
                .foregroundColor(.white)
                .background(isButtonDisabled ? .blue : .pink)
                .cornerRadius(10)
                
                
            } // VStack
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(.white)
            .cornerRadius(16)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 24)
            .frame(maxWidth: 640)
        } // VStack
        .padding()
    }
}



struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView()
            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
