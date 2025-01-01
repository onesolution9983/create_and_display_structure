import os
import json

def create_and_display_structure(base_path, structure):
    """
    Create a directory and file structure, then display it as a tree.
    
    Args:
        base_path (str): The root directory to create the structure in.
        structure (dict or list): A nested dictionary or list representing the structure.
    """
    def create_structure(path, items):
        tree_output = []
        for idx, item in enumerate(items):
            is_last = idx == len(items) - 1
            if isinstance(item, dict):  # Subfolder
                for folder, contents in item.items():
                    folder_path = os.path.join(path, folder)
                    os.makedirs(folder_path, exist_ok=True)
                    prefix = "└── " if is_last else "├── "
                    tree_output.append(f"{prefix}{folder}/")
                    nested_tree = create_structure(folder_path, contents)
                    tree_output.extend(["    " + line if is_last else "│   " + line for line in nested_tree])
            else:  # File
                file_path = os.path.join(path, item)
                with open(file_path, "w") as f:
                    pass
                prefix = "└── " if is_last else "├── "
                tree_output.append(f"{prefix}{item}")
        return tree_output

    # Create the base directory
    os.makedirs(base_path, exist_ok=True)
    print(f"{base_path}/")
    tree = create_structure(base_path, structure)
    for line in tree:
        print(line)

def main():
    # User provides the structure input
    user_input = input("Enter the path to your JSON file describing the structure: ").strip()

    # Load the structure from the file
    try:
        with open(user_input, "r") as f:
            structure = json.load(f)
    except Exception as e:
        print(f"Error loading structure: {e}")
        return

    # Ask for the base folder name
    base_folder = input("Enter the base folder name: ").strip()
    create_and_display_structure(base_folder, structure)

if __name__ == "__main__":
    main()