# Usage:
# gn issue create <gitlab url>
#
# Creates a new page on the Tasks database
gn() {
  if [ "$1" != "issue" ]; then
    echo "Invalid command: gn $1"
    return 1
  fi

  if [ "$2" = "list" ]; then
    local response=$(curl -sX POST https://api.notion.com/v1/data_sources/287935a7272f80d4a1efda6ceb6926e1/query \
      -H "Authorization: Bearer $NOTION_API_KEY" \
      -H "Content-Type: application/json" \
      -H "Notion-Version: 2025-09-03" \
    --data @- <<EOF
{
  "filter": {
    "or": [
      {
        "property": "Status",
        "status": {
          "equals": "Not started"
        }
      },
      {
        "property": "Status",
        "status": {
          "equals": "In progress"
        }
      } 
    ]
  }
}
EOF
)
  
    echo "$response" | jq

    return 0
  fi

  local issue_title=$(glab issue view $3 --output json | jq -r ".title")
  local response=$(curl -sX POST https://api.notion.com/v1/pages \
    -H "Authorization: Bearer $NOTION_API_KEY" \
    -H "Content-Type: application/json" \
    -H "Notion-Version: 2025-09-03" \
    --data @- <<EOF
{
  "parent": {
    "database_id": "287935a7272f80d4a1efda6ceb6926e1"
  },
  "properties": {
    "Title": {
      "title": [
        {
          "text": {
            "content": "${issue_title}"
          }
        }
      ]
    },
    "URL": {
      "url": "$3"
    },
    "Status": {
      "status": {
        "name": "Not started"
      }
    }
  }
}
EOF
)
  
  if echo "$response" | jq -e '.object == "error"' > /dev/null 2>&1; then
    echo "Error creating task:"
    echo "$response" | jq
  elif [ -n "$response" ]; then
    echo "Created a new task: $issue_title"
  else
    echo "Curl command failed."
  fi
}
