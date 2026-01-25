DEFAULT_PASSWORD="withgreatpowercomesgreatresponsibility"

def root
  # customers dot
  if Admin.is_a? Class
    Admin.find_by!(email: "root@gitlab.com")

  # gdk
  else
    User.find_by(username: "root")
  end
end

def password!
  root.update! password: DEFAULT_PASSWORD
end

def refetch_ironbank
  IronBank::LocalRecords.export
end
