import ROOT
import argparse
import json

def process_json(json_data):
    result = []
    
    for mass, value in json_data.items():
        for region, sub_value in value.items():
            obs_values = sub_value.get("obs", [])
            toy_values = sub_value.get("toy", [])
            p_values = sub_value.get("p", [])

            # Append the processed data to the result list
            result.append({
                "mass": mass,
                "region": region,
                "obs_values": obs_values,
                "toy_values": toy_values,
                "p_values": p_values
            })

    return result

def process_json_saturated(json_data):
    result= []

    for mass, info in json_data.items():
        obs = info['obs']
        p_value = info['p']
        toys = info['toy']

        result.append({
            "mass": mass,
            "region": 'saturated',
            "obs_values": obs,
            "toy_values": toys,
            "p_values": p_value
        })

    return result

def plot_goodness_of_fit_from_json(json_filename, algorithm, output,channel, year):
    with open(json_filename, 'r') as json_file:
        # data = json.load(json_file)
        json_data = json.load(json_file)

    # Process the JSON data
    if algorithm == "saturated":
        processed_data = process_json_saturated(json_data)
    else:
        processed_data = process_json(json_data)

    for item in processed_data:
        # Extract the values
        toys = item["toy_values"]
        obs = item["obs_values"][0]
        p_value= item["p_values"]
        region = item["region"]

        n_toys = len(toys)
        x_min = min(toys)
        x_max = max(toys)
        n_bins = 50  # Adjust as needed
        c = ROOT.TCanvas(f"c_{region}", "", 800, 800)

        histo = ROOT.TH1F(f"histo_{region}", "", n_bins, x_min, x_max)
        histo.SetLineWidth(2)
        histo.SetMarkerSize(1)
        histo.SetMarkerStyle(8)
        histo.SetMarkerColor(ROOT.kBlack)
        histo.SetLineColor(ROOT.kBlack)

        for value in toys:
            histo.Fill(value)
        
        #histo.Draw("P E")
        histo.Draw()
        histo.SetStats(0)

        histo.GetXaxis().SetTitle(f"GoF({algorithm})")
        histo.GetYaxis().SetTitle("Number of MC Toys")

        y_max = histo.GetMaximum()

        line = ROOT.TLine(obs, 0, obs, y_max)
        line.SetLineStyle(7)
        line.SetLineWidth(2)
        line.SetLineColor(ROOT.kRed)
        line.Draw()

        leg_right = ROOT.TLegend(0.63, 0.78, 0.88, 0.89)
        leg_right.SetTextSize(0.030)
        leg_right.SetBorderSize(0)
        leg_right.AddEntry("", f"p-value = {p_value}", "")
        leg_right.AddEntry(line, "Observed", "l")
        leg_right.AddEntry(histo, "Toys", "pel")
        leg_right.Draw()

        latex = ROOT.TLatex()
        latex.SetTextSize(0.04)
        if channel == "SL":
            latex.DrawLatexNDC(0.1, 0.91, "#font[42]{Leptons + jets}")
        elif channel == "DL":
            latex.DrawLatexNDC(0.1, 0.91, "#font[42]{Dilepton}")
        elif channel == "FH":
            latex.DrawLatexNDC(0.1, 0.91, "#font[42]{Fully hadronic}")
        latex.SetTextSize(0.045)
        latex.DrawLatexNDC(0.12, 0.86, "#font[61]{CMS}")
        latex.SetTextSize(0.035)
        latex.DrawLatexNDC(0.12, 0.82, "#font[52]{Internal}")
        latex_string = ROOT.TString()
        if algorithm == "saturated":
            if year == "2015":
                latex_string.Form("#font[42]{19.5 fb^{-1} (13.0 TeV)}")
                latex.DrawLatexNDC(0.635, 0.91, latex_string.Data())
            elif year == "2016":
                latex_string.Form("#font[42]{16.8 fb^{-1} (13.0 TeV)}")
                latex.DrawLatexNDC(0.635, 0.91, latex_string.Data())
            elif year == "2017":
                latex_string.Form("#font[42]{41.5 fb^{-1} (13.0 TeV)}")
                latex.DrawLatexNDC(0.635, 0.91, latex_string.Data())
            elif year == "2018":
                latex_string.Form("#font[42]{59.8 fb^{-1} (13.0 TeV)}")
                latex.DrawLatexNDC(0.635, 0.91, latex_string.Data())
        else:
            latex.DrawLatexNDC(0.53, 0.95, "#bf{#font[22]{Goodness of Fit for}}")
            latex_string.Form("#bf{#font[22]{%s}}" % region)
            latex.SetTextSize(0.035)
            latex.DrawLatexNDC(0.53, 0.91, latex_string.Data())


        c.SaveAs(f"{output}/GoF_{region}.png")
        c.SaveAs(f"{output}/GoF_{region}.pdf")




if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Plot Goodness-of-fit test from JSON file.")
    parser.add_argument("--json", dest="json_filename", required=True, help="Input JSON file")
    parser.add_argument("--algo", dest="algorithm", required=True, help="Algorithm used for Goodness Of Fit")
    parser.add_argument("--out", dest="output", required=True, help="Output path")
    parser.add_argument("--ch", dest="channel", required=False, help="Channel", default="SL")
    parser.add_argument("--y", dest="year", required=False, help="Year", default=2018)

    args = parser.parse_args()

    plot_goodness_of_fit_from_json(args.json_filename, args.algorithm, args.output, args.channel, args.year)

