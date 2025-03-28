#include <iostream>
#include <list>
#include <sstream>
#include <fstream>


// Need to reference what im passing in so this actually works 
void add_todo(std::list<std::string> todo_list, std::string todo) {
    size_t first_space = todo.find(' ');
    std::string tail = (first_space == std::string::npos) ? todo : todo.substr(first_space, todo.length());
    todo_list.push_back(tail);
}

void print_todos(std::list<std::string> todo_list) {
    
    int i = 1;
    for (auto iter = todo_list.begin(); iter != todo_list.end(); iter++, i++)
        std::cout << i << ": " << *iter << '\n';
    /*for (const auto& item : todo_list)*/
        /*std::cout << item << '\n';*/
}

void clear_screen() {
    std::system("clear");
} 

int main() {

    // Initiate variables for the list 
    std::list<std::string> todo_list;
    std::list<std::string>::iterator iter;
    std::string todo;

    // Read the db file in 
    std::ifstream read_file("db.txt");
    std::string line;
    while (std::getline(read_file, line))
        todo_list.push_back(line);
    read_file.close();

    // Main loop of the programming
    while (true) {
        clear_screen();
        std::cout << "C++ TODO List" << '\n' << "Type 'add this is my todo' to add" << '\n';
        std::cout << "Type 'del x' where x is the todo to delete" << '\n';
        print_todos(todo_list);

        // Get the entire string input 
        std::getline(std::cin, todo); 

        // Get the first word from the input
        std::istringstream stream(todo);
        std::string command;
        stream >> command;

        // Get the rest of the string after the command 
        size_t first_space = todo.find(' ');
        std::string tail = (first_space == std::string::npos) ? todo : todo.substr(first_space, todo.length());

        // Logic for what to do with the list of todos depending on command
        if (command == "add") {
            todo_list.push_back(tail);
        }
        else if (command == "del") {
            long index = std::stol(tail);  // TODO fix blank string after del command 
            if (index <= todo_list.size()) {
                auto iter = todo_list.begin();
                long i = 1;
                while (i != std::stol(tail)) 
                    iter++, i++;  
                todo_list.remove(*iter);
            }
        }
        else 
            ;  // do nothing if incorrect command.

        // Save the updated database 
        std::ofstream out_file("db.txt", std::ios::out);
        for (auto iter = todo_list.begin(); iter != todo_list.end(); iter++) 
            out_file << *iter << '\n';

        out_file.close();
    }
    return 0;
}
