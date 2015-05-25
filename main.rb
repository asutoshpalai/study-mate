require 'sinatra'

get '/' do
  title = "StudyMate::Home"
  erb :home, :locals => {:title => title}
end

get '/about' do
  erb :about, :locals => {:title => "StudyMata :: About"}
end

__END__
@@layout
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title><%if defined? title %><%=title%><%else%>StudyMate<%end%></title>
</head>
<body>
  <header>
    <h1>Songs By Sinatra</h1>
    <nav>
      <ul>
        <li><a href="/" title="Home">Home</a></li>
        <li><a href="/about" title="About">About</a></li>
      </ul>
    </nav>
  </header>
  <section>
    <%= yield %>
  </section>
</body>
</html>
@@home
<p>Welcome to StudyMate, solution to your reference woo</p>

@@about
<p>This site was created by me to learn sinatra</p>
