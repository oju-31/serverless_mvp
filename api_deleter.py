import os
import shutil
import re


def undo_backend_creation(module_name: str, api_name: str):
    """
    Undo the changes made by create_backend function.
    Returns True if successful, False if any errors occur.
    """
    try:
        # Define paths
        backend_path = "backend"
        tests_path = os.path.join(backend_path, "unit_tests")
        module_path = os.path.join(backend_path, module_name)
        api_pkg_path = os.path.join(module_path, f"{api_name}_pkg")
        test_module_path = os.path.join(tests_path, f"{module_name}_tests")

        # Remove files first
        files_to_remove = [
            os.path.join(api_pkg_path, f"{api_name}.py"),
            os.path.join(api_pkg_path, f"vldt_{api_name}.py"),
            os.path.join(test_module_path, f"test_{api_name}.py")
        ]

        for file_path in files_to_remove:
            if os.path.exists(file_path):
                os.remove(file_path)
                print(f"Removed file: {file_path}")

        # Remove directories (only if empty)
        dirs_to_remove = [
            api_pkg_path,
            module_path,
            test_module_path
        ]

        for dir_path in dirs_to_remove:
            if os.path.exists(dir_path):
                try:
                    os.rmdir(dir_path)
                    print(f"Removed empty directory: {dir_path}")
                except OSError:
                    # Directory not empty, check if we should force remove
                    if len(os.listdir(dir_path)) == 0:
                        shutil.rmtree(dir_path)
                        print(f"Removed directory tree: {dir_path}")
                    else:
                        print(f"Directory not removed as it contains other files: {dir_path}")

        # Clean up empty test directory if it exists and is empty
        if os.path.exists(tests_path) and len(os.listdir(tests_path)) == 0:
            os.rmdir(tests_path)
            print(f"Removed empty tests directory: {tests_path}")

        # Clean up empty backend directory if it exists and is empty
        if os.path.exists(backend_path) and len(os.listdir(backend_path)) == 0:
            os.rmdir(backend_path)
            print(f"Removed empty backend directory: {backend_path}")

        return True

    except Exception as e:
        print(f"Error during cleanup: {str(e)}")
        return False


def undo_infra_code(module_name: str, api_name: str):
    """
    Removes specific blocks of infrastructure code related to the given api_name
    """
    try:
        # Define the base path and file paths
        base_path = "infra/lambdas"
        files = {
            "data": (f"{base_path}/func_data.tf", f'data "archive_file" "{api_name}"', 5),
            "main": (f"{base_path}/func_main.tf", f'resource "aws_lambda_function" "{api_name}"', 20),
            "policies": (f"{base_path}/func_policies.tf", f'# {api_name.upper()} POLICY', 18),
            "roles": (f"{base_path}/func_roles.tf", f'# {api_name.upper()} ROLE', 18)
        }

        # Process each file
        for file_type, (file_path, search_line, lines_to_remove) in files.items():
            try:
                # Read all lines from the file
                with open(file_path, 'r') as f:
                    lines = f.readlines()

                # Find the line that matches our search string
                start_index = None
                for i, line in enumerate(lines):
                    if search_line in line:
                        start_index = i
                        break

                if start_index is not None:
                    # Remove the specified number of lines starting from the found line
                    lines = lines[:start_index] + lines[start_index + lines_to_remove:]
                    
                    # Write the modified content back
                    with open(file_path, 'w') as f:
                        f.writelines(lines)
                    
                    print(f"Successfully removed {api_name} block from {file_path}")
                else:
                    print(f"No matching block found in {file_path}")

            except FileNotFoundError:
                print(f"File not found: {file_path}")
            except Exception as e:
                print(f"Error processing {file_path}: {str(e)}")
                return False

        return True

    except Exception as e:
        print(f"Error during infrastructure code removal: {str(e)}")
        return False


undo_infra_code("core", "post_signup")
