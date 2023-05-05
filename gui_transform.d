import gtk.MainWindow;
import gtk.Button;
import gtk.SearchEntry;
import gtk.Main;
import gtk.VBox;
import std.stdio;
import std.string;

private import stdlib = core.stdc.stdlib : exit;

string[string] t;

class Buttons : MainWindow
{
        static string number;
        Button[] bs;
	this(string n)
	{
                number = n;
                t["kernel git"] = "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=%s";
                t["glibc git"] = "https://sourceware.org/git/?p=glibc.git;a=commit;h=%s";
                t["suse bugzilla"] = "https://bugzilla.suse.com/show_bug.cgi?id=%s";
                t["redhat bugzilla"] = "https://bugzilla.redhat.com/show_bug.cgi?id=%s";
                t["gcc bugzilla"] = "https://gcc.gnu.org/bugzilla/show_bug.cgi?id=%s";
                t["sourceware bugzilla"] = "https://sourceware.org/bugzilla/show_bug.cgi?id=%s";


		super("Gui Transform");
                VBox vbox = new VBox(false, 5);

                SearchEntry entry = new SearchEntry();
                entry.addOnSearchChanged(&searchChanged);
                vbox.add(entry);

                foreach (s, _; t) {
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
        string line;
        if ((line = readln().strip) is null)
                stdlib.exit(1);
	Main.init(args);
	new Buttons(line);
	Main.run();
}
