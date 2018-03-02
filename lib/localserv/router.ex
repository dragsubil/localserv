defmodule Localserv.Router do
  use Plug.Router

  plug :match
  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart],
    length: 100_000_0000
  plug :dispatch

  get "/" do
    dir_list = get_dir_list(root_dir())
    send_resp(conn, 200, render_page(:index, list: dir_list, path: "/"))
  end

  post "/upload_file" do
    case conn.body_params["fileupload"] do
      %Plug.Upload{} = upload_data ->
	save_file(upload_data)
	send_resp(conn, 200, "file uploaded successfully")
      _ -> send_resp(conn, 400, "invalid upload")
    end
  end

  post "/update_notes" do
    append_to_notes(conn.params["text"])
    send_resp(conn, 200, "notes added. go back and refresh")
  end
  
  
  get "/*path_list" do
    path = Enum.join(path_list, "/") 
    case File.exists?(root_dir() <> path) do
      true ->
	case File.dir?(root_dir() <> path) do
	  true ->
	    path = path <> "/"
	    dir_list = get_dir_list(root_dir() <> path)
	    send_resp(conn, 200, render_page(:index, list: dir_list, path: "/" <> path))
	  false ->
	    # i.e. its a file
	    {:ok, file_data} = File.read(root_dir() <> path)
	    send_resp(conn, 200, file_data)
	end
      false -> send_resp(conn, 404, "no such file")
    end
  end
  
  match _ do
    send_resp(conn, 404, "404 not found")
  end
  
  defp get_dir_list(path) do
    File.ls(path)
    |> elem(1)
    |> mark_subdirs(path)
  end
  
  defp mark_subdirs(dir_list, path) do
    Enum.map(dir_list,
      fn item ->
	if(File.dir?(path <> item), do: item <> "/", else: item)
      end
    )
  end
    
  defp render_page(:index, [list: dir_list, path: path]) do
    {:ok, file_contents} = get_notes_file_contents()
    Localserv.Template.index(dir_list, path, file_contents)
  end

  defp get_notes_file_contents do
    notes_file_path = root_dir() <> "localserv_notes.txt"
    if not File.exists?(notes_file_path) do
      File.touch(notes_file_path)
    end
    File.read(notes_file_path)
  end

  defp append_to_notes(text) do
    notes_file_path = root_dir() <> "localserv_notes.txt"
    File.write(notes_file_path, text, [:write])
    :ok
    end
    
  
    
  @doc """
  upload_data is a Plug.Upload struct
  """
  defp save_file(upload_data) do
    upload_dir = root_dir() <> "uploads/"
    case File.mkdir(upload_dir) do
      :ok -> File.cp(upload_data.path, upload_dir <> upload_data.filename)
      {:error, :eexist} -> File.cp(upload_data.path, upload_dir <> upload_data.filename)
    end
  end

  defp root_dir do
    File.cwd |> elem(1) |> (fn path -> path <> "/" end).()
  end
  
end    
      
     
      
    
