//
//  ContentView.swift
//  Todos
//
//  Created by Janne Vierimaa on 23/01/2021.
//  Copyright © 2021 Janne Vierimaa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
  @State private var newTodo = ""   //uusi tehtävä
  @State private var allTodos: [TodoItem] = []  //taulukko tehtäviä varten
  private let todosKey = "todosKey"
  
  var body: some View {
    NavigationView {
      VStack {
        HStack {
          TextField("Lisää tehtävä", text: $newTodo)      //luetaan tekstikentästä newTodo:n
            .textFieldStyle(RoundedBorderTextFieldStyle())

          Button(action: {
            guard !self.newTodo.isEmpty else { return }        //testataan että teksti ei ole tyhjä (erisuuri kuin)
            self.allTodos.append(TodoItem(todo: self.newTodo)) //lisätään listaan append metodin avulla
            self.newTodo = ""                                  //tyhjätään newTodo
            self.saveTodos()                                   //kutsutaan saveTodos tallenusmetodia
          }) {
            Image(systemName: "plus.").foregroundColor(.red)   //plusmerkin kuva lisäysnapiksi
          }
          .padding(.leading, 5)
        }.padding()

        List {
          ForEach(allTodos) { todoItem in
            Text(todoItem.todo)
          }.onDelete(perform: deleteTodo)
        }
      }
      .navigationBarTitle("Tehtävät")
    }.onAppear(perform: loadTodos)
  }

  private func saveTodos() {
    UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allTodos), forKey: todosKey)
  }

  private func loadTodos() {
    if let todosData = UserDefaults.standard.value(forKey: todosKey) as? Data {
      if let todosList = try? PropertyListDecoder().decode(Array<TodoItem>.self, from: todosData) {
        self.allTodos = todosList
      }
    }
  }
    private func markDone(){
    
    }
  private func deleteTodo(at offsets: IndexSet) {
    self.allTodos.remove(atOffsets: offsets)
    saveTodos()
  }
}

struct TodoItem: Codable, Identifiable {
  let id = UUID()
  let todo: String
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
