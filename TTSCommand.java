import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;


public class TTSCommand {

	
	public static String fileContent(String fileName) throws IOException{
		InputStream stream = new FileInputStream(new File(fileName));
		 BufferedReader br = new BufferedReader(new InputStreamReader(stream, "UTF-8"));
		 String everything="";
		    try {
		        StringBuilder sb = new StringBuilder();
		        String line = br.readLine();

		        while (line != null) {
		            sb.append(line);
		            line = br.readLine();
		        }
		        everything = sb.toString();
		       
		    } catch(Exception e) {
		        br.close();
		       
		    }
		    br.close();
		    return everything;
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
	
		try {
			// RandomAccessFile out=new RandomAccessFile("uni.txt","rws");
			PrintWriter out = new PrintWriter(new FileWriter("uni.txt"));
			System.out.println(args[0]);
			String value = fileContent(args[0]);
			int length = value.length();
			int uni1, uni2;
			for (int i = 0; i < length; i++) {
				if ((value.charAt(i) != ' ') && ((int) value.charAt(i) != 2404)
						&& (value.charAt(i) != '?') && (value.charAt(i) != '!')) {
					uni1 = (int) value.charAt(i);

					if (uni1 == 2306) {
						uni2 = (int) value.charAt(i + 1);
						if (uni2 >= 2325 && uni2 <= 2328) {// between ka to gha.
							out.print("2329 2381 ");
						} else if (uni2 >= 2330 && uni2 <= 2333) {// between cha
																	// to jha
							out.print("2334 2381 ");
						} else if (uni2 >= 2335 && uni2 <= 2338) {// between ta
																	// to dha
							out.print("2339 2381 ");
						} else if (uni2 >= 2340 && uni2 <= 2343) {// between ta
																	// to dhha
							out.print("2344 2381 ");
						} else if (uni2 >= 2346 && uni2 <= 2349) {// between pa
																	// to bha
							out.print("2350 2381 ");
						}

					}
					if (uni1 == 2407) {
						out.print("2319 2325");
					} else if (uni1 == 2408) {
						out.print("2342 2369 2311");
					} else if (uni1 == 2409) {
						out.print("2340 2367 2344");
					} else if (uni1 == 2410) {
						out.print("2330 2366 2352");
					} else if (uni1 == 2411) {
						out.print("2346 2366 2305 2330");
					} else if (uni1 == 2412) {
						out.print("2331");
					} else if (uni1 == 2413) {
						out.print("2360 2366 2340");
					} else if (uni1 == 2414) {
						out.print("2310 2336");

					} else if (uni1 == 2415) {
						out.print("2344 2380");
					} else if (uni1 == 2406) {
						out.print("2360 2370 2344 2381 2344 2366");
					} else {
						out.print("" + uni1);
					}
					if (value.charAt(i + 1) != ' ') {

						out.print(" ");
					}// end of if

				} else if ((int) value.charAt(i) == 2404) {
					out.println("\n");
				} else if (value.charAt(i) == '?') {
					out.println("?\n");
				} else if (value.charAt(i) == '!') {
					out.println("!\n");
				} else {

					out.print(">");
				}
			}// end of for

		out.close();
		

		} catch (IOException e) {
			e.printStackTrace();
		}


	}

}
