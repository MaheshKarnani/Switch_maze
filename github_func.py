import base64
from github import Github
from github import InputGitTreeElement
fd="C:\Data\Tmaze\\"
#os.chdir(fd)

g = Github("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")
repo = g.get_user().get_repo('Switch_maze') # repo name

animal_list=["34443624728","34443624890"]
tickatlab_list=["adf","asd"]
file_list=list()
file_names=list()
for i, entry in enumerate(animal_list):
    file_list.append(fd+animal_list[i]+"_weight.csv")
    file_names.append("wdata/"+tickatlab_list[i]+"_weight.csv")

commit_message = 'weights from 5s automatic measurement during entry'
master_ref = repo.get_git_ref('heads/main')
master_sha = master_ref.object.sha
base_tree = repo.get_git_tree(master_sha)

element_list = list()
for i, entry in enumerate(file_list):
    with open(entry) as input_file:
        data = input_file.read()
    element = InputGitTreeElement(file_names[i], '100644', 'blob', data)
    element_list.append(element)

tree = repo.create_git_tree(element_list, base_tree)
parent = repo.get_git_commit(master_sha)
commit = repo.create_git_commit(commit_message, tree, [parent])
master_ref.edit(commit.sha)