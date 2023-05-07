import gdk.Keysyms;
import gtk.Widget;
import gtk.MainWindow;
import gtk.Button;
import gtk.SearchEntry;
import gtk.Entry;
import gtk.CssProvider;
import gtk.Main;
import gtk.VBox;
import std.stdio;
import std.string;
import std.algorithm;
import std.file;
import std.path;

private import stdlib = core.stdc.stdlib : exit;

private enum conf_name = "~/.gui_transform";

private string[string] t;
private string label_css;

private class Buttons : MainWindow
{
        string input;
        Button[] bs;
	this(string _input)
	{
                input = _input;

		super("Gui Transform");
                VBox vbox = new VBox(false, 5);

                CssProvider css = new CssProvider();
                css.loadFromData(label_css);

                SearchEntry entry = new SearchEntry();
                entry.addOnSearchChanged(&searchChanged);
                entry.addOnKeyPress(&handleKeys);
                entry.addOnActivate(&handleEnter);

                vbox.addOnKeyPress(&handleKeys);
                vbox.add(entry);

                foreach (s; sort(t.keys)) {
                        Button exitbtn = new Button();
                        exitbtn.setLabel(s);
                        exitbtn.addOnClicked(&exitProg);
                        auto ctx = exitbtn.getStyleContext();
                        ctx.addClass(s.label_to_class);
                        ctx.addProvider(css, GTK_STYLE_PROVIDER_PRIORITY_USER);
                        vbox.add(exitbtn);
                        bs ~= exitbtn;
                }

		add(vbox);
		showAll();
	}

        bool handleKeys(GdkEventKey* e, Widget w)
        {
                if (e.keyval == GdkKeysyms.GDK_Escape) {
                        write(input);
                        stdlib.exit(0);
                }
                return false;
        }

        void handleEnter(Entry entry)
        {
                Button tmp;
                int counter = 0;
                foreach (v; bs)
                        if (v.isVisible()) {
                                tmp = v;
                                if (++counter > 1)
                                        return;
                        }
                if (counter == 1)
                        exitProg(tmp);
        }

        void searchChanged(SearchEntry entry) {
                string[] keywords = entry.getText().split;
                foreach (v; bs) {
                        bool to_show = true;
                        foreach (k; keywords)
                                if (indexOf(v.getLabel(), k) < 0) {
                                        v.hide();
                                        to_show = false;
                                        break;
                                }
                        if (to_show) v.show();
                }
        }

	void exitProg(Button button)
        {
                writef(t[button.getLabel()], input.strip_noise);
                stdlib.exit(0);
        }
}

void main(string[] args)
{
        load_config(expandTilde(args.length == 2 ? args[1] : conf_name));
        string line;
        if ((line = readln()) is null)
                stdlib.exit(1);
	Main.init(args);
	new Buttons(line);
	Main.run();
}

private void load_config(string path)
{
        try {
                auto f = File(path);
                string l;
                while ((l = f.readln().strip) !is null) {
                        if (l.length < 1 || l.startsWith("#"))
                                continue;
                        const string[] fields = l.split(",");
                        if (fields.length < 2)
                                continue;
                        const string key = fields[0].strip;
                        const string value = fields[1].strip;
                        if (key.length < 1 || value.length < 1)
                                continue;
                        t[key] = value;
                        label_css ~= make_style(key, fields.length < 3 ? "#eeeeee" : fields[2].strip);
                }
        }
        catch (Exception e)
        {
                write(e.msg);
                stdlib.exit(1);
        }
}

private string strip_noise(string s)
{
        s = s.strip();
        if (s.startsWith("bsc") || s.startsWith("bnc") || s.startsWith("bug"))
                s = s[3..$];
        if (s.startsWith("PR") || s.startsWith("pr") || s.startsWith("RH") || s.startsWith("rh"))
                s = s[2..$];
        return s.stripLeft("# ");
}

private string label_to_class(string s)
{
        return s.replace(' ', '_');
}

private string make_style(string s, string color)
{
        return format(".%s { color: %s; } ", s.label_to_class, color);
}
