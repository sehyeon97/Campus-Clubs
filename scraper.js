const puppeteer = require('puppeteer');
const fs = require('fs');

(async () => {
    try {
        // Open window
        const browser = await puppeteer.launch({
            "headless": false,
            "slow-mo": 50,
            "ignoreHTTPSErrors": true,
            "defaultViewport": null
        });
        const page = await browser.newPage();
        await page.goto("https://calbaptist.edu/life-at-cbu/community-life/clubs-and-organizations");
        await page.waitForSelector('.page-main-content');
        const content = await page.$('.page-main-content');

        // Get data
        const ps = await page.evaluate(el => {
            return Array.from(el.querySelectorAll('p')).map(p => p.textContent);
        }, content);
        const h2s = await page.evaluate(el2 => {
            return Array.from(el2.querySelectorAll('h2')).map(h2 => h2.textContent);
        }, content);

        // Extract href attributes from all links
        const hrefs = await page.evaluate(el3 => {
            return Array.from(el3.querySelectorAll('a')).map(link => link.href);
        }, content);

        // remove the first email because irrelevant
        hrefs.shift();
        const emails = [];
        for (let i = 0; i < hrefs.length; i++) {
            emails.push([hrefs[i].replace("mailto:", ""), hrefs[++i].replace("mailto:", "")]);
        }
        let emailCounter = 0;

        // Convert text to json string

        let json = [];
        let pCount = 8;

        for (const h2 of h2s) {
            let jsonObject = {
                name: h2,
                description: ps[pCount].replace(/\s+/g, ' ').replace(/\r?\n|\r/g, ' ').trim(),
                president: "",
                advisor: ""
            };

            if (ps[pCount + 1] === "President - Jose MendozaAdvisor - Mario Oyanader") {
                console.log("I did something");
                jsonObject.president = "Jose Mendoza";
                jsonObject.advisor = "Mario Oyanader";
                pCount -= 1;
            } else if (ps[pCount + 1] === "President - Adam Kneale") {
                // console.log("I did something else");
                // jsonObject.president = "Adam Kneale";
                // jsonObject.advisor = "TBD";
                // pCount -= 1;
            } else {
                jsonObject.president = ps[pCount + 1].replace("President - ", "");
                jsonObject.advisor = ps[pCount + 2].replace("Advisor - ", "");

                if (emailCounter < emails.length) {
                    jsonObject.president_email = emails[emailCounter][0];
                    jsonObject.advisor_email = emails[emailCounter][1];
                }
                emailCounter += 1;
            }

            json.push(jsonObject);
            pCount += 3;
        }

        // Remove parts of text
        // json = json.replace(/\s+/g, ' ');
        // json = json.replace(/President - /g, '');
        // json = json.replace(/Advisor - /g, '');
        // const jsonParse = JSON.parse(json.replace(/\r?\n|\r/g, ''));

        const jsonString = JSON.stringify(json, null, 2);

        // Save string to .json file
        fs.writeFile("output.json", jsonString, (err) => {
            if (err) {
                console.error("Error writing file:", err);
            } else {
                console.log("JSON file has been saved.");
            }
        });

        await browser.close();
    } catch (e) {
        console.log('error', e);
    }
})();