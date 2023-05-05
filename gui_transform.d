import gtk.MainWindow;
import gtk.Button;
import gtk.SearchEntry;
import gtk.Main;
import gtk.VBox;
import std.stdio;
import std.string;
import std.algorithm;
import std.file;
import std.path;

private import stdlib = core.stdc.stdlib : exit;

private string[string] t;

private class Buttons : MainWindow
{
        static string number;
        Button[] bs;
	this(string n)
	{
                number = n;

		super("Gui Transform");
                VBox vbox = new VBox(false, 5);

                SearchEntry entry = new SearchEntry();
                entry.addOnSearchChanged(&searchChanged);
                vbox.add(entry);

                foreach (s; sort(t.keys)) {
                        Button exitbtn = new Button();
                        exitbtn.setLabel(s);
                        exitbtn.addOnClicked(&exitProg);
                        vbox.add(exitbtn);
                        bs ~= exitbtn;
                }

		add(vbox);
		showAll();
	}

        void searchChanged(SearchEntry entry) {
                string[] keywords = entry.getText().split;
                foreach(v; bs) {
                        v.show();
                        foreach(k; keywords)
                                if (indexOf(v.getLabel(), k) < 0) {
                                        v.hide();
                                        break;
                                }
                }
        }

	void exitProg(Button button)
        {
                writef(t[button.getLabel()], number);
                stdlib.exit(0);
        }
}

void main(string[] args)
{
        load_file(expandTilde("~/.gui_transform"));
        string line;
        if ((line = readln().strip) is null)
                stdlib.exit(1);
	Main.init(args);
	new Buttons(line);
	Main.run();
}

private void load_file(string path)
{
        auto f = File(path);
        string l;
        while ((l = f.readln().strip) !is null) {
                if (l.length < 1 || l.startsWith("#"))
                        continue;
                const string[] fields = l.split(",");
                const string key = fields[0].strip;
                const string value = fields[1].strip;
                if (key.length < 1 || value.length < 1)
                        continue;
                t[key] = value;
        }
}
