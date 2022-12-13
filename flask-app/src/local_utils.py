# replaces the first_name and last_name keys with a single key called name
def concat_names(dic, first_name="first_name", last_name="last_name", name="name"):
    if first_name in dic and last_name in dic:
        dic[name] = dic[first_name] + " " + dic[last_name]
        del dic[first_name]
        del dic[last_name]
    return dic


# label the results of a query with the column names
def label_results(cursor, result):
    labeled = [
        concat_names(dict(zip([key[0] for key in cursor.description], row)))
        for row in result
    ]
    return labeled
