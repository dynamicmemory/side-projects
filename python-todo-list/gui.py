from tkinter import Tk, ttk, StringVar, NO
import database as db
import datetime as dt
# TODO - Consider simplifying edits, UX is very poor and not intuitive
# TODO - Add an SQLite database instead of a text file
DELIMTER = '^*#'


# ------------ FUNCTIONALITY --------------
def enter_button_function(event):
    add_task(task_text_box.getvar('default_var'))


def double_click_function(event) -> None:
    # Check to make sure an item in the list was double-clicked
    if len(tree_box.selection()) == 0:
       return


    # Get the double-clicked item and it's index in the treebox
    selected_item: tuple = tree_box.selection()
    items_index: int = tree_box.index(selected_item[0])

    # Get the corresponding item from the database and place it in the textbox
    database_item: list = db.read_from_db()
    clean_item: str = database_item[items_index].split(DELIMTER)[0]
    task_text_box.setvar('default_var', clean_item)


def get_time() -> str:
   return DELIMTER + dt.datetime.now().strftime("%d/%m/%y - %H:%M")


def add_task(todo: str) -> None:
    # Add a check for an empty to-do being added
    if todo == '':
        return

    # Add the text in the text box to the database
    db.append_to_db(todo+get_time())

    # Reset the txt box to empty for the next input
    task_text_box.setvar('default_var', '' )

    update_tree_box()


def delete_task() -> None:
    # Get a hold of the index of the users selected item to delete
    get_selected_item: tuple = tree_box.selection()

    # Check to make sure there is a selected list item to delete or the list isn't empty
    if len(get_selected_item) == 0:
        return

    index_of_selected: int = tree_box.index(get_selected_item[0])

    # Read in all the items in the to do list database
    lines: list = db.read_from_db()
    # Delete the line that matches the index obtained above
    lines.pop(index_of_selected)
    # Rewrite the list to the database without the deleted item
    db.write_to_db(lines)

    update_tree_box()


def edit_task(todo: str) -> None:
    # Get the selected item from the box
    selected_item: tuple = tree_box.selection()

    # Check to make sure an item has been selected
    if len(selected_item) == 0:
        return

    if task_text_box.getvar('default_var') == '':
        return

    item_index: int = tree_box.index(selected_item[0])

    database_file: list = db.read_from_db()
    database_file.insert(item_index, task_text_box.getvar('default_var')+get_time()+"\n")
    database_file.pop(item_index+1)

    db.write_to_db(database_file)
    tree_box.setvar('default_var', '')
    update_tree_box()


def move_down() -> None:
    # Get a hold of the highlight item
    get_selected_item: tuple = tree_box.selection()

    # Check to make sure there is a selected list item to delete or the list isn't empty
    if len(get_selected_item) == 0:
        return

    # Get the index number of the selected item
    index_of_selected: int = tree_box.index(get_selected_item[0])

    lines: list = db.read_from_db()
    item = lines.pop(index_of_selected)

    # If the length of the to do list is equal to the index of the selected item
    # Since we popped the item out, this should only be the case if the item was
    # last on the list as the off by one error. Therefore, put it to the front of
    # the list so that the users can move it to the top using down from the bottom
    if index_of_selected == len(lines):
        lines.insert(0, item)
    else:
        lines.insert(index_of_selected+1, item)

    db.write_to_db(lines)

    update_tree_box()

    # Selects the option the user initially selected before moving the item, allows for quick shifting of items in the
    # list. Same as comparing index to list size above, except now we have added
    # a new item to the list therefore the list is one size bigger so the index needs
    # to be incremented
    if index_of_selected + 1 == len(lines):
        tree_box.selection_set(tree_box.get_children()[0])
    else:
        tree_box.selection_set(tree_box.get_children()[index_of_selected + 1])


def move_up() -> None:
    # Get a hold of the index of the users selected item to delete
    get_selected_item: tuple = tree_box.selection()

    # Check to make sure there is a selected list item to delete or the list isn't empty
    if len(get_selected_item) == 0:
        return

    index_of_selected: int = tree_box.index(get_selected_item[0])


    lines: list = db.read_from_db()
    item = lines.pop(index_of_selected)

    # if the index of the selected item is the first in the box
    # then we want to make it appear as the last on the list so
    # the user can cycle from the top to the bottom like the down
    # button, but in reverse for better user experience.
    if index_of_selected == 0:
        lines.insert(len(lines)+1, item)
    else:
        lines.insert(index_of_selected - 1, item)

    db.write_to_db(lines)

    update_tree_box()

    # Selects the option the user initially selected before moving the item, allows for quick shifting of items in the
    # list.
    tree_box.selection_set(tree_box.get_children()[index_of_selected-1])


def update_tree_box() -> None:
    # Get all the items displayed in the tree box into a list
    box_items: tuple = tree_box.get_children()
    # Iterate through each item in the list and delete them from tree box view
    for item in box_items:
        tree_box.delete(item)

    # Get all the lines written in the database
    lines: list = db.read_from_db()
    # Iterate through each line and add it to the tree box view
    for entry in range(len(lines)):
        tree_box.insert('', 'end', values=(entry+1, lines[entry].split(DELIMTER)[0], lines[entry].split(DELIMTER)[1]), )

    task_text_box.focus_set()

# --------------- GUI BELOW ---------------
root = Tk()
root.title('TO-DO LIST')
# root.geometry('800x500')

# Frames
list_frame = ttk.Frame(root, padding=5)
list_frame.grid(row=0, column=0, sticky='NSEW')
button_frame = ttk.Frame(root, padding=5)
button_frame.grid(row=1, column=0, sticky='NSEW')

# Creates the list area to hold the list of to dos and adds a scrollbar
tree_box = ttk.Treeview(list_frame, columns=('1', '2', '3'), show='headings', selectmode='browse', height=20)
scrollbar = ttk.Scrollbar(list_frame, orient='vertical', command=tree_box.yview)
tree_box.configure(yscrollcommand=scrollbar.set)

tree_box.grid(row=0, column=0, sticky='NSEW')
scrollbar.grid(row=0, column=1, sticky='NSE')

# Controls the heading names for the columns as well as all variables concerning the columns
tree_box.heading('1', text='#')
tree_box.column('1', minwidth=0, width=25, stretch=NO)
tree_box.heading('2', text='Task')
tree_box.column('2', minwidth=0, width=550, stretch=NO)
tree_box.heading('3', text='Date')
tree_box.column('3', minwidth=0, width=115, stretch=NO)


# Adding a task to the list
default_text = StringVar(None, '', 'default_var')

# Where you type in  new to do
task_text_box = ttk.Entry(button_frame, textvariable = default_text)
task_text_box.grid(row=0, column=0, columnspan=5, sticky='NSEW')

add_button = ttk.Button(button_frame, text='Add', command=lambda :add_task(task_text_box.getvar('default_var')))
add_button.grid(row=1, column=0, sticky='NSEW')

delete_button = ttk.Button(button_frame, text='Delete', command=delete_task)
delete_button.grid(row=1, column=1, sticky='NSEW')

edit_button = ttk.Button(button_frame, text='Edit', command=lambda:edit_task(task_text_box.getvar('default_var')))
edit_button.grid(row=1, column=2, sticky='NSEW')

move_up_button = ttk.Button(button_frame, text="Up", command=move_up)
move_up_button.grid(row=1, column=3, sticky='NSEW')

move_down_button = ttk.Button(button_frame, text="Down", command=move_down)
move_down_button.grid(row=1, column=4, sticky='NSEW')

# Enables the ability to add items with the enter key
root.bind('<Return>', enter_button_function)
root.bind('<Double-Button-1>', double_click_function)

# completed_button = ttk.Button(button_frame, text='Completed')
# completed_button.grid(row=0, column=3, sticky='NSEW')

# Resize code
root.grid_columnconfigure(0, weight=1)
list_frame.grid_columnconfigure(0, weight=1000)
list_frame.grid_columnconfigure(1, weight=1)
button_frame.grid_columnconfigure(0, weight=1)
button_frame.grid_columnconfigure(1, weight=1)
button_frame.grid_columnconfigure(2, weight=1)
button_frame.grid_columnconfigure(3, weight=1)
button_frame.grid_columnconfigure(4, weight=1)
button_frame.grid_columnconfigure(5, weight=1)

root.grid_rowconfigure(0, weight=10)
root.grid_rowconfigure(1, weight=1)
list_frame.grid_rowconfigure(0, weight=1)
list_frame.grid_rowconfigure(1, weight=1)

# Main run
update_tree_box()
