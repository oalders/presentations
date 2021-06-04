package main

import (
	"fmt"
	"log"
	"net/url"

	"github.com/pariz/gountries"
)

func main() {
	url, err := url.Parse("https://www.google.com/search?q=schitt%27s+creek")
	if err != nil {
		log.Fatal(err)
	}
	q := url.Query()
	fmt.Println(q.Get("q")) // nolintforbidigo

	countryObj, err := gountries.New().FindCountryByAlpha("CA")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("CA is also: %s", countryObj.Codes.Alpha3) // nolintforbidigo
}
