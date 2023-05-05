import gtk.MainWindow;
import gtk.Button;
import gtk.SearchEntry;
import gtk.Main;
import gtk.VBox;
import std.stdio;
import std.string;

private import stdlib = core.stdc.stdlib : exit;

void function(string)[string] t;

class Buttons : MainWindow
{
        static string number;
        Button[] bs;
	this(string n)
	{
                number = n;
                t["kernel git"] = (s) => writef("https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=%s", s);
                t["glibc git"] = (s) => writef("https://sourceware.org/git/?p=glibc.git;a=commit;h=%s", s);
                t["suse bugzilla"] = (s) => writef("https://bugzilla.suse.com/show_bug.cgi?id=%s", s);
                t["redhat bugzilla"] = (s) => writef("https://bugzilla.redhat.com/show_bug.cgi?id=%s", s);
                t["gcc bugzilla"] = (s) => writef("https://gcc.gnu.org/bugzilla/show_bug.cgi?id=%s", s);
                t["sourceware bugzilla"] = (s) => writef("https://sourceware.org/bugzilla/show_bug.cgi?id=%s", s);


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
                string s = entry.getText();
                foreach(v; bs) {
                        if (indexOf(v.getLabel(), s) >= 0)
                                v.show();
                        else
                                v.hide();
                }
        }

	void exitProg(Button button)
        {
                t[button.getLabel()](number);
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
