core = 7.x
api = 2

;Boostrap base theme and related modules
projects[bootstrap][version] = "3.4"
projects[bootstrap][type] = "theme"

project[views_bootstrap][version] = "3.1"
project[views_bootstrap][subdir] = "contrib"


; Independent modules
projects[] = elements
projects[elements][subdir] = "contrib"
projects[] = fences
projects[fences][subdir] = "contrib"
projects[] = html5_tools
projects[html5_tools][subdir] = "contrib"
projects[] = block_class
projects[block_class][subdir] = "contrib"
projects[] = semanticviews
projects[semanticviews][subdir] = "contrib"
