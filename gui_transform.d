import gtk.MainWindow;
import gtk.Button;
import gtk.Main;
import gtk.VBox;
import std.stdio;
import std.format;
import std.string;

private import stdlib = core.stdc.stdlib : exit;

void function(string)[string] t;

class Buttons : MainWindow
{
        static string number;
	this(string n)
	{
                number = n;
                t["kernel linus"] = (s) => writef("https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=%s", s);
                t["suse bugzilla"] = (s) => writef("https://bugzilla.suse.com/show_bug.cgi?id=%s", s);
                t["redhat bugzilla"] = (s) => writef("https://bugzilla.redhat.com/show_bug.cgi?id=%s", s);
                t["gcc bugzilla"] = (s) => writef("https://gcc.gnu.org/bugzilla/show_bug.cgi?id=%s", s);
                t["sourceware bugzilla"] = (s) => writef("https://sourceware.org/bugzilla/show_bug.cgi?id=%s", s);


		super("Gui Transform");
                VBox vbox = new VBox(true, 5);
                foreach (s, _; t) {
                        Button exitbtn = new Button();
                        exitbtn.setLabel(s);
                        exitbtn.addOnClicked(&exitProg);
                        vbox.add(exitbtn);
                }
		add(vbox);
		showAll();
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
