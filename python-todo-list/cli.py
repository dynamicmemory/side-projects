import database
import datetime as dt
import os
import platform

# TODO - Rerwtie delete and eidt so that they use the same function for checking
# if user input is within the index of the list length
# TODO - Rewrite all of this, since this is a quick rewrite on top of old code
# in a single afternoon as i just wanted to see if i prefer a cli version instead
# of a gui, its all rushed and not thought out well, as well as using the existing
# db structure to not break the gui.... can be improved alot.

DELIMTER = "^*#"

# Currently in a CLI mock up phase of how I want this to look, will convert
# this all to gui next
TO_DO_LIST: list = []
COMPLETED_TASKS: list = []


def get_commands() -> None:
    print('add - adds a new task to your to-do list e.g. add poop today')
    print('delete - deletes a task from your to-do list e.g delete 4')
    print('edit - edit the contents of a task e.g edit 2')
    print('close - exits the program')

def get_time() -> str:
   return DELIMTER + dt.datetime.now().strftime("%d/%m/%y - %H:%M")


def add_task(todo: str) -> None:
    #add_question: str = input('Add something to do \n')
    
    database.append_to_db(todo+get_time())

    #TO_DO_LIST.append(add_question)


def delete_task(answer) -> None:
    deleted_task: bool = False
    db = database.read_from_db()
    # Control input

    # This check is if someone enters delete but doesnt supply an int for a todo
    # to delete from the list.
    if answer == None:
        deleted_task = True

    while not deleted_task:
        if len(db) < 1:
            print('There are no tasks to remove')
            break
        else:
            # to stop the except index error from complaining (poor design on my behalf obs)
            delete_question = 0
            try:
                # delete_question: int = int(input('Which to-do number would you like to remove?\n'))

                # Control for lower bounds of list index
                if answer < 1:
                    print('Please enter an integer greater than 0')
                else:
                
                    
                    db.pop(int(answer) - 1)
                    database.write_to_db(db)
                    deleted_task = True

            # Control for strings instead of ints and numbers outside of the list length
            except ValueError:
                print('Please enter the integer index number of a task you wish to delete')
            except IndexError:
                print(f'Task index number: {delete_question} doesnt exist, please enter the index number of a '
                      f'task you wish to delete')


def edit_task(answer) -> None:
    # This check is if someone enters the edit command but doesnt supply an int
    # for a todo in the list to edit
    if answer == None:
        return
    # edit_question: int = int(input('Which task number would you like to edit')) - 1
    answer = answer - 1
    # Wipe it from the db
    db = database.read_from_db()

    # Save the todo in text for to show the user what to edit
    todo_to_edit = db[answer].split("^*#")[0]+"\n"
    
    db.pop(answer)
    
    print("\n"+"You want to edit: "+todo_to_edit)
    edited_task: str = input('What would you like to edit this to do too?\n')

    db.insert(answer, edited_task+get_time()+'\n')
    database.write_to_db(db)

def display_to_dos() -> None:

    print('\n')
    print('------------------------------------------------------------')
    to_dos = database.read_from_db()
    #for i in to_dos:
    #    print(i)
    for num in range(len(to_dos)):

        # This is an absolutely lazy way to format the to do, fix this shit up!
        to_do = to_dos[num].split("^*#")[0]+"\n"
        date = to_dos[num].split("^*#")[1].split(" ")[0]+" - "
        print(f'{num + 1 :3d}: {date + to_do}')
    

def get_marching_orders() -> tuple:
    question: str = input('\nWhat would you like to do? \n')
    answer = None
    
    # You have once again found the ugliest most inefficent way of doing something
    # House of mother fucking cards, change this shit asap.
    if len(question) > 3 and question[:3] == "add":
        command = "add"
        todo = question[4:]
        return (command, todo)
    elif question[:6] == "delete": 
        command = question.split(' ')[0]
        try:
            answer = int(question.split(' ')[1]) 
        except (ValueError):
            print("Enter a valid number to delete")
            answer = None
    elif question[:4] == "edit": 
        command = question.split(' ')[0]
        try:
            answer = int(question.split(' ')[1]) 
        except (ValueError):
            print("Enter a valid number to Edit")
            answer = None
    elif question[:5] == "close":
        command = question.split(' ')[0]
    else:
        command = None

    #print(command, answer)
    return (command, answer) 


def incorrect_input(question: str) -> None:
    print(f'"{question}" is not a valid command, possible commands are:')
    get_commands()


def clear_terminal():
    if platform == "Windows":
        os.system('cls')
    else:
        os.system('clear')


def main() -> None:

    while True:
        clear_terminal() 
        get_commands()
        display_to_dos()
        
        command, answer = get_marching_orders()

        # Lists all commands for the user
        # if command == 'cmd':
        #     get_commands()

        # add a task to do
        if command == 'add':
            add_task(answer)

        # Delete a task
        elif command == 'delete':
            delete_task(answer)

        elif command == 'edit':
            edit_task(answer)

        elif command == 'close':
            clear_terminal()
            exit(1)

        else:
            # incorrect_input(command)
            pass


if __name__ == '__main__':
    main()
