""" Requests and Selenium tests for project """
# Author: Diana Melnychuk
# Reviewer:
import time
import unittest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.common.exceptions import TimeoutException


class TestProjectImage(unittest.TestCase):
    drive = None
    test_host = "172.17.0.1"

    @classmethod
    def setUpClass(cls):
        """ Setup before testing """
        options = webdriver.ChromeOptions()
        options.add_argument('--ignore-ssl-errors=yes')
        options.add_argument('--ignore-certificate-errors')
        cls.drive = webdriver.Remote(
            command_executor='http://selenium:4444/wd/hub',
            options=options
        )

    @classmethod
    def tearDownClass(cls):
        """ Teardown after testing """
        cls.drive.quit()

    def test_positive_path(self):
        self.drive.get(f"http://{self.test_host}")
        header = self.drive.find_element(By.TAG_NAME, 'h1')
        self.assertEqual(header.text, "Weather forecast:", "Page header should be Weather forecast")

    def test_negative_path(self):
        self.drive.get(f"http://{self.test_host}/asd")
        header = self.drive.find_element(By.TAG_NAME, 'h1')
        self.assertEqual(header.text, "Not Found", "Page header should be not found")

    def test_positive_location(self):
        positive_search = "Tel Aviv"
        # Load page
        self.drive.get(f"http://{self.test_host}/")
        # Find search bar
        search_bar = self.drive.find_element(By.NAME, 'search')
        search_bar.send_keys(positive_search, Keys.ENTER)
        # Wait for element to be present
        element_present = EC.presence_of_element_located((By.TAG_NAME, 'h4'))
        try:
            WebDriverWait(self.drive, 10).until(element_present)
        except TimeoutException:
            self.fail("Title element wasn't found")
        # Get search response
        found = self.drive.find_element(By.TAG_NAME, "h4")
        # Check search response
        self.assertIn(positive_search, found.text)

    def test_negative_location(self):
        negative_search = "Tel Avivfghfghfghfgh"
        # Load page
        self.drive.get(f"http://{self.test_host}/")
        # Find search bar
        search_bar = self.drive.find_element(By.NAME, 'search')
        search_bar.send_keys(negative_search, Keys.ENTER)
        # Wait for element to be present
        element_present = EC.presence_of_element_located((By.CLASS_NAME, 'display-6'))
        try:
            WebDriverWait(self.drive, 10).until(element_present)
        except TimeoutException:
            self.fail("Not Found element wasn't found")

        # Get search response
        found = self.drive.find_element(By.CLASS_NAME, 'display-6')
        # Check search response
        self.assertIn("Not Found", found.text)


if __name__ == '__main__':
    unittest.main()
