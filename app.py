from flask import Flask, render_template, request, session
import dns.resolver
import socket
import whois

app = Flask(__name__)
app.secret_key = "FKDCtech2025"  # needed for session

def fetch_dns_info(domain_name):
    result = {}

    # NS
    try:
        ns_records = dns.resolver.resolve(domain_name, 'NS')
        result['ns'] = [str(rdata) for rdata in ns_records]
    except:
        result['ns'] = []

    # A
    try:
        a_records = dns.resolver.resolve(domain_name, 'A')
        result['a'] = [str(rdata) for rdata in a_records]
    except:
        result['a'] = []

    # CNAME
    try:
        cname_records = dns.resolver.resolve("www." + domain_name, 'CNAME')
        result['cname'] = [str(rdata) for rdata in cname_records]
    except:
        result['cname'] = []

    # MX
    try:
        mx_records = dns.resolver.resolve(domain_name, 'MX')
        result['mx'] = [f"{r.preference} {r.exchange}" for r in mx_records]
    except:
        result['mx'] = []

    # TXT / SPF
    try:
        txt_records = dns.resolver.resolve(domain_name, 'TXT')
        result['txt'] = [str(rdata) for rdata in txt_records]
    except:
        result['txt'] = []

    # PTR
    try:
        ptr = socket.gethostbyaddr(domain_name)
        result['ptr'] = [ptr[0], ptr[2]]
    except:
        result['ptr'] = []

    # Reverse Lookup
    try:
        ip = result['ptr'][1][0]
        rev = socket.gethostbyaddr(ip)
        result['reverse'] = rev[0]
    except:
        result['reverse'] = ""

    # WHOIS
    try:
        w = whois.whois(domain_name)
        result['whois'] = {
            "domain_name": w.domain_name,
            "status": w.status,
            "registrar": w.registrar,
            "creation_date": w.creation_date,
            "updated_date": w.updated_date,
            "expiration_date": w.expiration_date,
            "country": w.country,
        }
    except:
        result['whois'] = {}

    # SOA
    try:
        soa_records = dns.resolver.resolve(domain_name, 'SOA')
        result['soa'] = []
        for r in soa_records:
            result['soa'].append({
                "serial": r.serial,
                "rname": r.rname.to_text(),
                "refresh": r.refresh,
                "retry": r.retry,
                "expire": r.expire,
                "minimum": r.minimum,
                "mname": r.mname.to_text()
            })
    except:
        result['soa'] = []

    return result


@app.route("/", methods=["GET", "POST"])
def index():
    dns_data = None
    current_domain = None

    history = session.get("history", [])  # list of previous domains

    if request.method == "POST":
        current_domain = request.form.get("domain", "").strip()
        if current_domain:
            dns_data = fetch_dns_info(current_domain)

            # update history (latest on top, unique, max 10)
            if current_domain in history:
                history.remove(current_domain)
            history.insert(0, current_domain)
            history = history[:10]
            session["history"] = history

    return render_template(
        "index.html",
        dns_data=dns_data,
        history=history,
        current_domain=current_domain
    )


if __name__ == "__main__":
    app.run(debug=True, port=8443)  # your custom port
