import json
import uuid


# Iterate through each submission ID and generate commands
submission_ids = [
    "submission_297968",
    "submission_297899",
    "submission_297944",
    "submission_297947",
    "submission_297948",
    "submission_297908",
    "submission_297863",
    "submission_297949",
    "submission_297952",
    "submission_297909",
    "submission_297959",
    "submission_297864",
    "submission_297874",
    "submission_297924",
    "submission_297926",
    "submission_297927",
    "submission_297928",
    "submission_297929",
    "submission_297930",
    "submission_297931",
    "submission_297932",
    "submission_297933",
    "submission_297934",
    "submission_297935",
    "submission_297936",
    "submission_297937",
    "submission_297938",
    "submission_297939",
    "submission_297940",
    "submission_297941",
    "submission_297984",
    "submission_297942",
    "submission_297943",
    "submission_307667",
    "submission_307670",
    "submission_307672",
    "submission_307674",
    "submission_307676",
    "submission_307679",
    "submission_307681",
    "submission_307683",
    "submission_307686",
    "submission_307688",
    "submission_307691",
    "submission_307693",
    "submission_307695",
    "submission_297985",
    "submission_307698",
    "submission_307699",
    "submission_307701",
    "submission_307703",
    "submission_297872",
    "submission_297873",
    "submission_297875",
    "submission_297876",
    "submission_297877",
    "submission_297878",
    "submission_297923",
    "submission_297879",
    "submission_297880",
    "submission_297881",
    "submission_307754",
    "submission_307705",
    "submission_307709",
    "submission_307749",
    "submission_307711",
    "submission_307714",
    "submission_307716",
    "submission_307719",
    "submission_307721",
    "submission_307723",
    "submission_307725",
    "submission_307728",
    "submission_307730",
    "submission_307761",
    "submission_297892",
    "submission_297910",
    "submission_297911",
    "submission_297912",
    "submission_297913",
    "submission_297914",
    "submission_297915",
    "submission_297916",
    "submission_297917",
    "submission_297918",
    "submission_297919",
    "submission_297920",
    "submission_297894",
    "submission_297896",
    "submission_297897",
    "submission_297898",
    "submission_297900",
    "submission_297901",
    "submission_297902",
    "submission_297903",
    "submission_297904",
    "submission_297905",
    "submission_297906",
    "submission_297907",
    "submission_297865",
    "submission_297866",
    "submission_297867",
    "submission_297868",
    "submission_297869",
    "submission_297870",
    "submission_297882",
    "submission_297883",
    "submission_297884",
    "submission_297886",
    "submission_297887",
    "submission_297888",
    "submission_297889",
    "submission_297891",
    "submission_297893",
    "submission_297921",
    "submission_297922",
    "submission_297945",
    "submission_297953",
    "submission_297954",
    "submission_297955",
    "submission_297956",
    "submission_297957",
    "submission_297958",
    "submission_297960",
    "submission_297961",
    "submission_297962",
    "submission_297963",
    "submission_297964",
    "submission_297969",
    "submission_297970",
    "submission_307756",
    "submission_297965",
    "submission_297973",
    "submission_297974",
    "submission_297975",
    "submission_297976",
    "submission_297977",
    "submission_297978",
    "submission_297979",
    "submission_297980",
    "submission_297981",
    "submission_297982",
    "submission_297983",
    "submission_297986",
    "submission_297987",
    "submission_297988"
]

# List to hold all commands
all_commands = []

for submission_id in submission_ids:
    # Generate a new command for each submission ID
    new_command = [{
        "id": uuid.uuid4().__str__(),
        "comment": "",
        "command": "click",
        "target": f"css=#{submission_id} > .title > a",
        "targets": [
            [f"css=#{submission_id} > .title > a", "css:finder"],
            ["xpath=//a[contains(text(),'2- [CF] -  KC - Introducción a la informática en la nube')]", "xpath:link"],
            ["xpath=//tr[@id='submission_297899']/th/a", "xpath:idRelative"],
            ["xpath=//a[contains(@href, '/courses/2217/assignments/297899/submissions/55986')]", "xpath:href"],
            ["xpath=//tr[6]/th/a", "xpath:position"]
        ],
        "value": ""
    }
        , {
            "id": uuid.uuid4().__str__(),
            "comment": "",
            "command": "selectFrame",
            "target": "index=1",
            "targets": [
                ["index=1"]
            ],
            "value": ""
        }, {
            "id": uuid.uuid4().__str__(),
            "comment": "",
            "command": "click",
            "target": "id=viewSubmissionTree",
            "targets": [
                ["id=viewSubmissionTree", "id"],
                ["css=#viewSubmissionTree", "css:finder"],
                ["xpath=//span[@id='viewSubmissionTree']", "xpath:attributes"],
                ["xpath=//div[@id='filelistbuttons']/span", "xpath:idRelative"],
                ["xpath=//div[3]/div[2]/span", "xpath:position"],
                ["xpath=//span[contains(.,'Submissions ')]", "xpath:innerText"]
            ],
            "value": ""
        }, {
            "id": uuid.uuid4().__str__(),
            "comment": "",
            "command": "click",
            "target": "css=.tree-folder:nth-child(3) .icon-plus",
            "targets": [
                ["css=.tree-folder:nth-child(3) .icon-plus", "css:finder"],
                ["xpath=//div[@id='trees3']/div[3]/div/i", "xpath:idRelative"],
                ["xpath=//div[3]/div/i", "xpath:position"]
            ],
            "value": ""
        }, {
            "id": uuid.uuid4().__str__(),
            "comment": "",
            "command": "click",
            "target": "css=.tree-folder-content > .tree-folder:nth-child(1) .icon-plus",
            "targets": [
                ["css=.tree-folder-content > .tree-folder:nth-child(1) .icon-plus", "css:finder"],
                ["xpath=//div[@id='trees3']/div[3]/div[2]/div/div/i", "xpath:idRelative"],
                ["xpath=//div[4]/div[3]/div[2]/div/div/i", "xpath:position"]
            ],
            "value": ""
        }, {
            "id": uuid.uuid4().__str__(),
            "comment": "",
            "command": "click",
            "target": "css=.tree-item:nth-child(1)",
            "targets": [
                ["css=.tree-item:nth-child(1)", "css:finder"],
                ["xpath=//div[@id='trees3']/div[3]/div[2]/div/div[2]/div", "xpath:idRelative"],
                ["xpath=//div[3]/div[2]/div/div[2]/div", "xpath:position"]
            ],
            "value": ""
        }, {
            "id": uuid.uuid4().__str__(),
            "comment": "",
            "command": "click",
            "target": "id=downloadbtn",
            "targets": [
                ["id=downloadbtn", "id"],
                ["css=#downloadbtn", "css:finder"],
                ["xpath=//div[@id='downloadbtn']", "xpath:attributes"],
                ["xpath=//div[@id='filelistbuttons']/div[8]", "xpath:idRelative"],
                ["xpath=//div[2]/div[8]", "xpath:position"]
            ],
            "value": ""
        }, {
            "id": uuid.uuid4().__str__(),
            "comment": "",
            "command": "click",
            "target": "linkText=Download zipped source",
            "targets": [
                ["linkText=Download zipped source", "linkText"],
                ["css=.btn-warning", "css:finder"],
                ["xpath=//a[contains(text(),'Download zipped source')]", "xpath:link"],
                ["xpath=//div[@id='div-output-download_from_ide']/a", "xpath:idRelative"],
                [
                    "xpath=//a[contains(@href, '/projects/common/kintaroloop@gmail.com_2915386_s2915386_2123613_Feb_28_2024_6-28-45am_PST.zip')]",
                    "xpath:href"],
                ["xpath=//div[2]/a", "xpath:position"],
                ["xpath=//a[contains(.,'Download zipped source')]", "xpath:innerText"]
            ],
            "value": ""
        }, {
            "id": uuid.uuid4().__str__(),
            "comment": "",
            "command": "selectFrame",
            "target": "relative=parent",
            "targets": [
                ["relative=parent"]
            ],
            "value": ""
        }, {
            "id": uuid.uuid4().__str__(),
            "comment": "",
            "command": "click",
            "target": "css=.comments",
            "targets": [
                ["css=.comments", "css:finder"],
                ["xpath=//div[@id='content']/div[3]/div[2]/div/div", "xpath:idRelative"],
                ["xpath=//div/div[3]/div[2]/div/div", "xpath:position"]
            ],
            "value": ""
        }, {
            "id": uuid.uuid4().__str__(),
            "comment": "",
            "command": "click",
            "target": "linkText=Grades",
            "targets": [
                ["linkText=Grades", "linkText"],
                ["css=.grades", "css:finder"],
                ["xpath=//a[contains(text(),'Grades')]", "xpath:link"],
                ["xpath=//ul[@id='section-tabs']/li[3]/a", "xpath:idRelative"],
                ["xpath=//a[contains(@href, '/courses/2217/grades')]", "xpath:href"],
                ["xpath=//div[2]/div/nav/ul/li[3]/a", "xpath:position"],
                ["xpath=//a[contains(.,'Grades')]", "xpath:innerText"]
            ],
            "value": ""
        }]
    json_string = json.dumps(new_command, indent=4)

    # Append the new command to the list
    all_commands.append(new_command)

# Save the commands to a file
with open('commands.json', 'w') as json_file:
    json.dump(all_commands, json_file, indent=4)