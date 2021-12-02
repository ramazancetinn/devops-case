import sys

# get the file path
file =  sys.argv[1:][0]

users = {}
with open(file) as f:
    lines = f.readlines()
    lines = [line.rstrip() for line in lines]
    for line in lines:
        user_object = line.split(":")
        id = user_object[1]
        user = user_object[0]
        # push user by id to user dict
        if id not in users:
            users[id] = []
        users[id].append(user)

for key,value in users.items():
    # if any id has more than one value print the values
    if len(value) > 1:
        dupe_users = ",".join(value)
        print("{}: {}".format(key,dupe_users ))