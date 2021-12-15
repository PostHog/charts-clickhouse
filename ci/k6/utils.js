// Return true if the IP address is part of a private IP space:
//
//  * 10.0.0.0 - 10.255.255.255
//  * 172.16.0.0 - 172.31.255.255
//  * 192.168.0.0 - 192.168.255.255
export function isPrivateIP(ip) {
    var parts = ip.split('.');
    return parts[0] === '10' ||
       (parts[0] === '172' && (parseInt(parts[1], 10) >= 16 && parseInt(parts[1], 10) <= 31)) ||
       (parts[0] === '192' && parts[1] === '168');
 }
